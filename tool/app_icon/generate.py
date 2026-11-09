#!/usr/bin/env python3
"""Sinh icon app (iOS + Android adaptive) từ một hình vẽ duy nhất.

Cần `rsvg-convert` (brew install librsvg). Chạy: python3 tool/app_icon/generate.py
"""
import math
import pathlib
import subprocess
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[2]
IOS_DIR = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
ANDROID_RES = ROOT / "android/app/src/main/res"
MASTER_SVG = ROOT / "docs/design/app-icon.svg"

PRIMARY_LIGHT, PRIMARY_DARK = "#9A6CF0", "#6237C4"
STAR_TOP, STAR_BOTTOM = "#FFD54A", "#F5B000"
CHECK = "#4B2AA6"

CX, CY, R_OUT = 512, 540, 300
R_IN = R_OUT * 0.55
STAR_ROUNDING = 96
# Vùng nhìn thấy của adaptive icon là 72dp trên layer 108dp.
ADAPTIVE_SCALE = 72 / 108

ANDROID_DENSITIES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def star_path():
    pts = []
    for i in range(10):
        a = math.radians(-90 + i * 36)
        r = R_OUT if i % 2 == 0 else R_IN
        pts.append(f"{CX + r * math.cos(a):.1f},{CY + r * math.sin(a):.1f}")
    return "M" + " L".join(pts) + "Z"


STAR = star_path()
CHECK_PATH = f"M{CX - 116},{CY + 6} L{CX - 36},{CY + 84} L{CX + 122},{CY - 80}"


def sparkle(x, y, s, fill, opacity=1.0):
    k = s * 0.22
    return (
        f'<path d="M{x},{y - s} Q{x + k},{y - k} {x + s},{y} Q{x + k},{y + k} {x},{y + s} '
        f'Q{x - k},{y + k} {x - s},{y} Q{x - k},{y - k} {x},{y - s}Z" '
        f'fill="{fill}" opacity="{opacity}"/>'
    )


DEFS = f"""<defs>
  <linearGradient id="bg" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="1024" y2="1024">
    <stop offset="0" stop-color="{PRIMARY_LIGHT}"/><stop offset="1" stop-color="{PRIMARY_DARK}"/>
  </linearGradient>
  <radialGradient id="glow" gradientUnits="userSpaceOnUse" cx="307" cy="225" r="717">
    <stop offset="0" stop-color="#FFFFFF" stop-opacity="0.22"/>
    <stop offset="1" stop-color="#FFFFFF" stop-opacity="0"/>
  </radialGradient>
  <linearGradient id="star" gradientUnits="userSpaceOnUse" x1="0" y1="200" x2="0" y2="860">
    <stop offset="0" stop-color="{STAR_TOP}"/><stop offset="1" stop-color="{STAR_BOTTOM}"/>
  </linearGradient>
  <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
    <feGaussianBlur stdDeviation="16"/>
  </filter>
  <mask id="checkCut" maskUnits="userSpaceOnUse" x="0" y="0" width="1024" height="1024">
    <rect width="1024" height="1024" fill="#FFFFFF"/>
    <path d="{CHECK_PATH}" fill="none" stroke="#000000" stroke-width="70"
      stroke-linecap="round" stroke-linejoin="round"/>
  </mask>
</defs>"""

# Rect tràn ra ngoài 0..1024 để vẫn phủ kín canvas khi bị thu nhỏ cho adaptive.
BACKGROUND = """<rect x="-256" y="-256" width="1536" height="1536" fill="url(#bg)"/>
<rect x="-256" y="-256" width="1536" height="1536" fill="url(#glow)"/>"""

ROUND = f'stroke-width="{STAR_ROUNDING}" stroke-linejoin="round"'
FOREGROUND = f"""<path d="{STAR}" transform="translate(0,26)" fill="#3A1C8C" stroke="#3A1C8C"
  {ROUND} opacity="0.35" filter="url(#shadow)"/>
<path d="{STAR}" fill="url(#star)" stroke="url(#star)" {ROUND}/>
<path d="{CHECK_PATH}" fill="none" stroke="{CHECK}" stroke-width="70"
  stroke-linecap="round" stroke-linejoin="round"/>
{sparkle(208, 236, 62, "#FFFFFF", 0.95)}
{sparkle(826, 262, 38, "#FFB3CF")}
{sparkle(836, 812, 40, "#FFFFFF", 0.85)}
<circle cx="214" cy="790" r="20" fill="#8EE6B2"/>"""

# Themed icon (Android 13+) chỉ dùng kênh alpha, nên dấu tick phải là lỗ thủng.
MONOCHROME = f"""<path d="{STAR}" fill="#FFFFFF" stroke="#FFFFFF" {ROUND} mask="url(#checkCut)"/>"""


def svg(body, scale=1.0, clip=None):
    t = f"translate(512 512) scale({scale}) translate(-512 -512)"
    clip_defs, clip_attr = "", ""
    if clip:
        clip_defs = f'<clipPath id="clip">{clip}</clipPath>'
        clip_attr = ' clip-path="url(#clip)"'
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" '
        f'width="1024" height="1024">{DEFS}{clip_defs}'
        f'<g{clip_attr}><g transform="{t}">{body}</g></g></svg>'
    )


def render(svg_text, size, out):
    out.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile("w", suffix=".svg") as f:
        f.write(svg_text)
        f.flush()
        subprocess.run(
            ["rsvg-convert", "-w", str(size), "-h", str(size), f.name, "-o", str(out)],
            check=True,
        )


def main():
    full = svg(BACKGROUND + FOREGROUND)
    MASTER_SVG.write_text(full)

    for png in sorted(IOS_DIR.glob("Icon-App-*.png")):
        # Tên file dạng Icon-App-83.5x83.5@2x.png.
        pt, scale = png.stem.removeprefix("Icon-App-").split("@")
        render(full, round(float(pt.split("x")[0]) * int(scale.rstrip("x"))), png)

    inset = 1024 * 2 / 48
    legacy = svg(
        BACKGROUND + FOREGROUND,
        scale=(1024 - 2 * inset) / 1024,
        clip=f'<rect x="{inset}" y="{inset}" width="{1024 - 2 * inset}" '
        f'height="{1024 - 2 * inset}" rx="190"/>',
    )
    layers = {
        "ic_launcher_background": svg(BACKGROUND, ADAPTIVE_SCALE),
        "ic_launcher_foreground": svg(FOREGROUND, ADAPTIVE_SCALE),
        "ic_launcher_monochrome": svg(MONOCHROME, ADAPTIVE_SCALE),
    }
    for density, factor in ANDROID_DENSITIES.items():
        folder = ANDROID_RES / f"mipmap-{density}"
        render(legacy, round(48 * factor), folder / "ic_launcher.png")
        for name, layer in layers.items():
            render(layer, round(108 * factor), folder / f"{name}.png")

    adaptive = ANDROID_RES / "mipmap-anydpi-v26/ic_launcher.xml"
    adaptive.parent.mkdir(parents=True, exist_ok=True)
    adaptive.write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@mipmap/ic_launcher_background" />\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground" />\n'
        '    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />\n'
        "</adaptive-icon>\n"
    )


if __name__ == "__main__":
    main()
