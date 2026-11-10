#!/usr/bin/env bash
# Builds a release and installs it over Wi-Fi on a paired iPad (or the given device).
# Each run re-signs with the free Personal Team, extending the 7-day signature.
# Usage: tool/install_ios.sh [device name | UDID]    (env: IOS_DEVICE, WAIT_SECONDS)
set -euo pipefail

readonly ALLOWED_TEAM="V5TR223894"
readonly WAIT_SECONDS="${WAIT_SECONDS:-30}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
readonly ROOT
readonly PBXPROJ="$ROOT/ios/Runner.xcodeproj/project.pbxproj"
readonly DERIVED="$ROOT/build/ios_device"
readonly APP="$DERIVED/Build/Products/Release-iphoneos/Runner.app"
target="${1:-${IOS_DEVICE:-}}"

die() { printf '✗ %b\n' "$*" >&2; exit 1; }
step() { printf '▸ %s\n' "$*"; }

# CLAUDE.md forbids letting Xcode register anything with a company team.
check_team() {
  local teams
  teams=$(grep -oE 'DEVELOPMENT_TEAM = [A-Z0-9]+;' "$PBXPROJ" | awk '{print $3}' | tr -d ';' | sort -u)
  [[ "$teams" == "$ALLOWED_TEAM" ]] ||
    die "DEVELOPMENT_TEAM là '$(paste -sd, - <<<"$teams")', không phải $ALLOWED_TEAM (xem CLAUDE.md). Dừng, không build."
}

# Prints "udid<TAB>tunnelState<TAB>developerMode<TAB>name" for paired devices matching $target.
list_devices() {
  local json
  json=$(mktemp -t ios_devices)
  if ! xcrun devicectl list devices --json-output "$json" >/dev/null 2>&1; then
    rm -f "$json"
    die "Không chạy được 'xcrun devicectl' (cần Xcode 15 trở lên)."
  fi
  jq -r --arg t "$target" '
    .result.devices[]?
    | select(.connectionProperties.pairingState == "paired")
    | select(if $t == "" then .hardwareProperties.deviceType == "iPad"
             else ($t == .hardwareProperties.udid or $t == .identifier
                   or (.deviceProperties.name | ascii_downcase | contains($t | ascii_downcase))) end)
    | [.hardwareProperties.udid, (.connectionProperties.tunnelState // "unknown"),
       (.deviceProperties.developerModeStatus // "unknown"), (.deviceProperties.name // "?")]
    | @tsv' "$json"
  rm -f "$json"
}

# Polls because a device that just woke up can take a few seconds to show on the network.
find_device() {
  local deadline=$((SECONDS + WAIT_SECONDS)) rows reachable
  while :; do
    rows=$(list_devices) || exit 1
    [[ -n "$rows" ]] ||
      die "Không có thiết bị đã ghép đôi nào khớp '${target:-iPad}'. Cắm cáp một lần để Mac ghép đôi với máy."
    reachable=$(awk -F'\t' '$2 != "unavailable"' <<<"$rows")
    if [[ -n "$reachable" ]]; then
      [[ $(wc -l <<<"$reachable") -eq 1 ]] ||
        die "Có nhiều thiết bị khớp, hãy truyền tên hoặc UDID:\n$(awk -F'\t' '{print "  " $4 "  " $1}' <<<"$reachable")"
      echo "$reachable"
      return
    fi
    ((SECONDS < deadline)) ||
      die "Không thấy '$(cut -f4 <<<"$rows" | paste -sd, -)' trên mạng. Mở khóa máy và cho cùng Wi-Fi với Mac."
    echo "… đang chờ thiết bị xuất hiện trên Wi-Fi (mở khóa máy)" >&2
    sleep 3
  done
}

build_app() {
  local udid=$1
  step "Cấu hình Flutter (release)"
  (cd "$ROOT" && flutter build ios --config-only --release)
  step "Build và ký bằng team $ALLOWED_TEAM"
  # A concrete destination makes Xcode register this device in the free team's profile.
  xcodebuild -quiet \
    -workspace "$ROOT/ios/Runner.xcworkspace" -scheme Runner -configuration Release \
    -destination "id=$udid" -derivedDataPath "$DERIVED" \
    -allowProvisioningUpdates -allowProvisioningDeviceRegistration \
    build
}

main() {
  if [[ "$target" == "-h" || "$target" == "--help" ]]; then
    sed -n '2,4s/^# //p' "$0"
    exit 0
  fi
  check_team

  local device udid devmode name profile signed_team expires
  device=$(find_device)
  IFS=$'\t' read -r udid _ devmode name <<<"$device"
  step "Thiết bị: $name ($udid)"
  [[ "$devmode" != "disabled" ]] ||
    die "Bật Developer Mode trên máy: Cài đặt › Quyền riêng tư & Bảo mật › Chế độ nhà phát triển."

  build_app "$udid"

  profile=$(security cms -D -i "$APP/embedded.mobileprovision")
  signed_team=$(plutil -extract TeamIdentifier.0 raw -o - - <<<"$profile")
  [[ "$signed_team" == "$ALLOWED_TEAM" ]] || die "App được ký bằng team $signed_team, không cài."
  expires=$(plutil -extract ExpirationDate raw -o - - <<<"$profile")

  step "Cài lên $name"
  xcrun devicectl device install app --device "$udid" "$APP"

  echo "✓ Đã cài. Chữ ký hết hạn lúc $expires, chạy lại script trước lúc đó để gia hạn."
  echo "  Lần đầu: Cài đặt › Cài đặt chung › Quản lý VPN & thiết bị › tin cậy nhà phát triển."
}

main
