# Kế hoạch phát triển app "Bảng việc của các bé"

App Flutter (Android và iOS) giúp bố mẹ và các bé theo dõi việc hằng ngày, tích sao, tích điểm và đổi thưởng.
Tính năng và giao diện lấy theo mẫu [Bảng việc của các bé](https://claude.ai/artifact/4Swq87kD26qksGpWUwru3P).
Chi tiết giao diện xem ở [design-system.md](design-system.md).

- App id: `com.nvstudio.todo`
- Flutter 3.47.7 / Dart 3.13.5

## 1. Mục tiêu

1. Mỗi bé tự bấm sao khi làm xong một việc, thấy ngay điểm của mình tăng.
2. Bố mẹ quản lý danh sách việc, phần thưởng và ghi chú theo tuần.
3. Tạo động lực bằng **level**, **streak** và **đổi thưởng**.
4. Chạy **offline**, dữ liệu lưu trên máy. Đồng bộ giữa nhiều máy để giai đoạn sau.

## 2. Tính năng (theo mẫu)

| # | Tính năng | Mô tả |
|---|---|---|
| F1 | Hồ sơ bé | Số bé thay đổi được: **thêm bé** (bắt buộc nhập tên), **đổi tên**, **xoá bé** (có popup xác nhận). Mặc định có 2 bé, luôn còn ít nhất 1 bé. Các bé **dùng chung danh sách việc**, nhưng **mỗi bé có bảng sao, điểm và ghi chú riêng**. |
| F2 | Tuần | Tuần chạy từ T2 đến CN. Có nút chuyển tuần trước/sau, khoảng ngày định dạng theo ngôn ngữ app (vi: `9/11 – 15/11/2026`). |
| F3 | Việc bắt buộc | Danh sách việc hằng ngày, mỗi việc có emoji, tên và điểm (+2, +3). |
| F4 | Việc tự chọn | Danh sách việc khuyến khích, mỗi việc có emoji, tên và điểm (+2 → +5). |
| F5 | Đánh dấu sao | Bấm ngôi sao ở ô (việc × ngày) để bật/tắt "đã làm" và cộng/trừ điểm. **Chỉ đánh sao được cho hôm nay và các ngày đã qua**; ô của ngày tương lai bị khoá. |
| F6 | Tổng điểm | Tổng theo từng việc trong tuần (cột Tổng), tổng theo ngày (dòng cuối bảng). |
| F7 | Điểm của tôi | Điểm hôm nay, tuần này, tổng đã tích, còn lại để đổi. |
| F8 | Đổi thưởng | Danh sách phần thưởng theo giá sao. Chưa đủ thì hiện "Cần thêm X điểm". Đủ thì cho đổi, nhưng **bố mẹ phải nhập mã PIN** rồi mới trừ điểm. |
| F9 | Level | 4 level tính theo **tổng đã tích** (đổi thưởng không làm tụt level), có thanh tiến độ và câu "Còn X điểm nữa để lên Level N". |
| F10 | Streak bonus | Làm hết việc bắt buộc đủ 7/7 ngày **trong cùng một tuần T2–CN** thì được +10 điểm, không tính nối tiếp xuyên tuần. Hiển thị chip T2…CN và tiến độ "x/7". |
| F11 | Ghi chú tuần | Ô ghi chú của bố mẹ cho **từng bé**, từng tuần. |
| F12 | Sửa danh sách | Thêm/sửa/xoá việc (emoji, tên, điểm) và phần thưởng; thêm, đổi tên, xoá bé; đổi mã PIN. |
| F13 | Mã PIN bố mẹ | Mã 4 số để xác nhận đổi thưởng. Tạo ở lần đổi thưởng đầu tiên (nhập 2 lần). Đổi PIN phải nhập PIN cũ. |
| F14 | Ngôn ngữ | Toàn bộ giao diện theo ngôn ngữ chọn trong app (Theo hệ thống / English / Tiếng Việt): tiếng Việt thì **toàn bộ** là tiếng Việt, English thì **toàn bộ** là tiếng Anh, không xen kẽ như mẫu. Dữ liệu mặc định (tên bé, việc, phần thưởng, tên level) cũng đổi theo. |

## 3. Luật tính điểm

Ký hiệu: `d` là một ngày, `W` là một tuần (T2–CN), `k` là một bé.

```
pointsOn(k, d)    = Σ điểm các việc k đã đánh sao trong ngày d
weekPoints(k, W)  = Σ pointsOn(k, d) với d ∈ W  +  streakBonus(k, W)
streakBonus(k, W) = 10 nếu cả 7 ngày của W, k đều làm HẾT việc bắt buộc; ngược lại 0
totalEarned(k)    = Σ weekPoints(k, W) trên mọi tuần
available(k)      = totalEarned(k) − Σ giá các phần thưởng k đã đổi
level(k)          = theo totalEarned(k):
                    0–49 → L1 · 50–99 → L2 · 100–149 → L3 · ≥150 → L4
```

Ghi chú:
- Khi đánh sao, lưu lại **điểm của việc lúc đó**. Sau này sửa điểm của việc thì lịch sử cũ không bị đổi.
- Xoá việc là **ẩn** (soft delete): việc không còn trong danh sách nhưng điểm cũ vẫn giữ.
- "Làm hết việc bắt buộc trong ngày d" chỉ xét các việc bắt buộc đang có hiệu lực vào ngày d.
- Không có completion cho ngày sau hôm nay (theo ngày trên máy). Vì vậy tuần hiện tại chỉ có streak bonus khi tới CN và đủ 7/7.
- Level tính theo tổng đã tích, nên đổi thưởng **không làm tụt level**.

## 4. Dữ liệu mặc định (lấy từ mẫu)

Mỗi mục có chữ tiếng Việt và tiếng Anh, hiển thị theo ngôn ngữ app (cách lưu xem mục 7).
Bản dịch tiếng Anh là đề xuất, cần duyệt lại.

**Bé**

| Tiếng Việt | English |
|---|---|
| Bé 1 | Kid 1 |
| Bé 2 | Kid 2 |

**Việc bắt buộc**

| Emoji | Tiếng Việt | English | Điểm |
|---|---|---|---|
| 🛏️ | Tự gấp chăn/gọn giường sau khi ngủ dậy | Make the bed after waking up | 2 |
| 🪥 | Đánh răng sáng + tối | Brush teeth morning + night | 2 |
| 👕 | Tự mặc quần áo và bỏ đồ bẩn đúng chỗ | Get dressed and put dirty clothes in the basket | 2 |
| 🎒 | Chuẩn bị cặp sách/đồ đi học | Pack the school bag | 2 |
| 🍴 | Ăn uống gọn gàng, không cần nhắc nhiều | Eat neatly without many reminders | 2 |
| 🧸 | Dọn đồ chơi sau khi chơi | Put toys away after playing | 2 |
| 📚 | Hoàn thành bài tập/việc học trong ngày | Finish today's homework | 3 |
| 🚿 | Tắm rửa, thay đồ, chuẩn bị đi ngủ | Bath, pajamas, ready for bed | 2 |

**Việc tự chọn**

| Emoji | Tiếng Việt | English | Điểm |
|---|---|---|---|
| 📖 | Đọc sách 15–20 phút | Read for 15–20 minutes | 3 |
| 🧹 | Chủ động giúp một việc nhà | Offer to help with a chore | 3 |
| 🧺 | Gấp/cất quần áo | Fold or put away clothes | 2 |
| 🪴 | Tưới cây/chăm cây | Water or care for the plants | 2 |
| 🎨 | Vẽ, làm thủ công hoặc hoạt động sáng tạo | Draw, craft or make something | 2 |
| 👟 | Vận động ngoài trời ≥30 phút | Play outside for 30+ minutes | 3 |
| 🇬🇧 | Học tiếng Anh thêm 15 phút | 15 extra minutes of English | 2 |
| 💡 | Học một điều mới và kể lại cho bố mẹ | Learn something new and tell Mom or Dad | 3 |
| ❤️ | Tự làm một việc tốt mà không cần bố mẹ nhắc | Do a good deed without being asked | 5 |

**Phần thưởng**

| Giá | Emoji | Tiếng Việt | English |
|---|---|---|---|
| 20 | 🍦 | Chọn món tráng miệng yêu thích | Pick a favorite dessert |
| 30 | 🎬 | Chọn phim xem cùng gia đình | Pick the family movie |
| 40 | 🎲 | Chọn trò chơi gia đình | Pick the family game |
| 50 | 🚗 | Được chọn địa điểm đi chơi cuối tuần | Choose the weekend outing |
| 70 | 🎁 | Một món đồ nhỏ bé thích | A small treat of your choice |
| 100 | 🎡 | Một trải nghiệm đặc biệt: đi chơi, workshop, khu vui chơi… | A special experience: a trip, a workshop, a theme park… |

**Level**

| Level | Emoji | Tiếng Việt | English | Điểm |
|---|---|---|---|---|
| 1 | 🌱 | Trợ thủ nhí | Little Helper | 0–49 |
| 2 | 🌿 | Siêu trợ thủ | Super Helper | 50–99 |
| 3 | 🪴 | Người hùng gia đình | Family Hero | 100–149 |
| 4 | 🌳 | Bé tự lập | Independent Kid | 150+ |

## 5. Màn hình

Mọi màn phải chạy đúng trên phone, máy gập và tablet, ở cả chiều dọc lẫn chiều ngang (quy ước trong [CLAUDE.md](../CLAUDE.md)).
Bố cục cụ thể cho từng nhóm thiết bị xem ở [design-system.md, mục 6](design-system.md#6-bố-cục-theo-thiết-bị).

### 5.1 Điện thoại và màn ngoài máy gập (`compact`)

Điều hướng bằng 4 tab: `NavigationBar` ở dưới khi cầm dọc, `NavigationRail` bên trái khi cầm ngang.
Header (tiêu đề, chip chọn bé, chuyển tuần) dùng chung cho các tab. Nhóm chip chọn bé cuộn ngang khi có nhiều bé.

| Tab | Nội dung |
|---|---|
| **Hôm nay** | Thẻ điểm (F7). Thanh chọn ngày T2…CN, mặc định là hôm nay. Danh sách việc bắt buộc rồi tự chọn của ngày đang chọn, mỗi dòng có emoji, tên, "+điểm" và một ngôi sao lớn. Chọn ngày tương lai thì vẫn xem được danh sách nhưng ngôi sao bị khoá. Cuối danh sách là tổng điểm ngày. |
| **Cả tuần** | Bảng tuần như mẫu web (F6): cột tên việc cố định, cuộn ngang các cột ngày và cột Tổng. |
| **Đổi thưởng** | "Còn X điểm", lưới 2 cột thẻ phần thưởng (F8), lịch sử đã đổi. |
| **Thành tích** | Level (F9), Streak (F10), Ghi chú tuần của bé đang chọn (F11). |

### 5.2 Tablet và màn trong máy gập (`medium` trở lên)

Một màn **Dashboard** cuộn được, giống mẫu web: header, bảng tuần, Điểm, Đổi thưởng, Level, Streak và Ghi chú.
- Cầm ngang: Điểm và Đổi thưởng nằm ở cột phụ bên phải.
- Cầm dọc: Điểm và Đổi thưởng xếp bên dưới bảng tuần.

Khi gập hoặc mở máy, app chuyển giữa Tab và Dashboard mà vẫn giữ nguyên bé, tuần và ngày đang chọn.

### 5.3 Màn phụ (mọi thiết bị)

- **Sửa danh sách** (mở từ nút ✏️ trên header): hai tab Bắt buộc / Tự chọn, kéo để sắp xếp, thêm/sửa/xoá việc. Có thêm mục Phần thưởng, mục Các bé và mục Mã PIN.
  - Form thêm/sửa việc (chọn emoji, tên, điểm) mở dạng bottom sheet trên `compact`, dạng dialog rộng tối đa 480–560 từ `medium` trở lên.
  - **Các bé**: danh sách bé, kéo để sắp xếp. Thêm bé mở form có ô tên bắt buộc, nút **Thêm** khoá khi tên trống. Bấm vào bé để đổi tên. Khi chỉ còn 1 bé thì không có nút xoá.
  - **Mã PIN**: đổi PIN (nhập PIN cũ, rồi PIN mới 2 lần).
- **Xác nhận đổi thưởng**: dialog "Đổi 20 ⭐ lấy 'Chọn món tráng miệng yêu thích'?", rồi bố mẹ nhập PIN 4 số. Sai PIN thì báo lỗi và cho nhập lại; đúng thì trừ điểm và bắn confetti. Chưa có PIN thì bước này là tạo PIN (nhập 2 lần).
- **Xác nhận xoá bé**: dialog "Xoá Bé 1?" nói rõ sẽ mất hết sao, điểm, lịch sử đổi thưởng và ghi chú của bé, không khôi phục được. Hai nút **Huỷ** và **Xoá**.

## 6. Kiến trúc

| Hạng mục | Lựa chọn | Lý do |
|---|---|---|
| Quản lý state | `flutter_riverpod` | Dễ test, tách logic khỏi UI, hợp với stream từ DB |
| Lưu trữ local | `drift` (SQLite) | Dữ liệu có quan hệ (bé × việc × ngày), dễ truy vấn tổng điểm, có migration |
| Điều hướng | `go_router` (`StatefulShellRoute` cho tab dưới) | Giữ state từng tab, sau này dễ thêm deep link |
| Ngày/giờ, i18n | `intl`, `flutter_localizations` (ARB `en`, `vi`) | Định dạng ngày theo ngôn ngữ app, tính tuần T2–CN |
| Cài đặt nhỏ | `shared_preferences` | Đã dùng cho ngôn ngữ. Mã PIN lưu dạng hash kèm salt, không lưu số gốc |
| Font | Baloo 2, Be Vietnam Pro (đóng gói trong assets) | Chạy offline |
| Hiệu ứng | `flutter_animate`, `confetti` | Hiệu ứng sao và đổi thưởng |
| Test | `flutter_test`, `mocktail` | Unit test cho luật điểm, widget test cho màn hình |

**Cấu trúc thư mục**

```
lib/
  main.dart
  app.dart                     # MaterialApp.router + theme
  core/
    theme/                     # app_theme, app_colors, app_typography, app_spacing
    layout/                    # breakpoints, LayoutClass, LayoutConfig (theo shortestSide + orientation)
    router/                    # go_router config
    utils/                     # date/week helpers
  data/
    db/                        # drift database, tables, migrations, seed
    repositories/              # kid, task, completion, reward, note repositories
  domain/
    models/                    # Kid, TaskItem, Completion, Reward, Redemption, WeekNote
    scoring/                   # points, streak, level calculators (thuần Dart, có test)
  features/
    today/                     # tab Hôm nay
    week/                      # tab Cả tuần
    rewards/                   # tab Đổi thưởng
    progress/                  # tab Thành tích (level, streak, notes)
    manage/                    # Sửa danh sách
  widgets/                     # KidChip, WeekSwitcher, StarToggle, PointsCard, ...
test/
  domain/scoring/              # unit test luật tính điểm
  features/                    # widget test (chạy ở nhiều kích thước màn hình)
```

**Quy ước code:** theo [CLAUDE.md](../CLAUDE.md):
- Mỗi function có tối đa 3 dòng comment, comment nói vì sao chứ không nói làm gì.
- Layout phải đúng trên mọi nhóm thiết bị và cả hai chiều màn hình.
- Mọi chữ hiển thị lấy từ ARB (`lib/l10n/app_en.arb`, `app_vi.arb`), không hard-code. Bảng chữ ở [design-system.md, mục 8](design-system.md#8-bảng-chữ-en--vi).

## 7. Mô hình dữ liệu (bảng drift)

| Bảng | Cột chính |
|---|---|
| `kids` | `id`, `seedKey?`, `name?`, `sortOrder`, `createdAt` |
| `tasks` | `id`, `seedKey?`, `emoji`, `title?`, `points`, `type` (`mustDo` / `optional`), `sortOrder`, `createdAt`, `archivedAt?` |
| `completions` | `id`, `kidId`, `taskId`, `date` (yyyy-MM-dd), `points` (lưu lúc đánh sao), `createdAt`. Khoá duy nhất: (`kidId`, `taskId`, `date`) |
| `rewards` | `id`, `seedKey?`, `emoji`, `title?`, `cost`, `sortOrder`, `archivedAt?` |
| `redemptions` | `id`, `kidId`, `rewardId`, `cost` (lưu lúc đổi), `redeemedAt` |
| `week_notes` | `kidId`, `weekStart` (ngày T2), `text`, `updatedAt`. Khoá chính: (`kidId`, `weekStart`) |

- Streak bonus **không lưu**, mà tính từ `completions` và `tasks`. Cách này tránh sai lệch khi bỏ sao.
- **Chữ theo ngôn ngữ:** dòng do app seed có `seedKey` và để trống `name`/`title`, khi hiển thị thì lấy chuỗi ARB theo `seedKey` và ngôn ngữ app. Bố mẹ sửa chữ thì lưu vào `name`/`title` và từ đó không dịch nữa. Dòng bố mẹ tự thêm luôn có chữ.
- **Xoá bé** là xoá hẳn (không phải ẩn như việc): `completions`, `redemptions`, `week_notes` của bé xoá theo (`ON DELETE CASCADE`).

## 8. Lộ trình

### Giai đoạn 0: Nền tảng
- [x] Khởi tạo project Flutter (Android, iOS)
- [x] Đổi app id sang `com.nvstudio.todo`
- [x] Chọn ngôn ngữ trong app (Theo hệ thống / English / Tiếng Việt), chuỗi giao diện trong ARB
- [ ] Thêm dependency (riverpod, drift, go_router, intl, flutter_animate, confetti)
- [ ] Bật lint chặt hơn (`very_good_analysis` hoặc tự cấu hình)
- [ ] Thêm font vào assets, dựng `AppTheme` sáng/tối theo [design-system.md](design-system.md)
- [ ] Dựng `LayoutClass` và `LayoutConfig` (breakpoint, khoảng cách, số cột) theo design-system mục 6, kèm unit test chọn nhóm theo kích thước
- [ ] Khung điều hướng chuyển giữa Tab và Dashboard theo `LayoutClass`, state đặt trong provider để không mất khi gập/mở máy
- [ ] Màn "gallery" nội bộ để xem các component

### Giai đoạn 1: Dữ liệu và luật tính điểm
- [ ] Schema drift, migration v1, seed dữ liệu mặc định (mục 4) kèm `seedKey`, chữ mặc định trong ARB `en`/`vi`
- [ ] Các repository (xoá bé xoá theo dữ liệu của bé)
- [ ] `scoring/`: `pointsOn`, `weekPoints`, `streak`, `totalEarned`, `available`, `level`
- [ ] Unit test đủ các trường hợp biên: tuần qua tháng/năm, bỏ sao, việc bị ẩn giữa tuần, sửa điểm việc, chặn đánh sao ngày tương lai, xoá bé

### Giai đoạn 2: Màn Hôm nay
- [ ] Header: tiêu đề nhiều màu, `KidChip` (cuộn ngang khi nhiều bé), `WeekSwitcher`
- [ ] `PointsCard`
- [ ] Thanh chọn ngày T2…CN với màu pastel
- [ ] Danh sách việc bắt buộc và tự chọn, `StarToggle` có hiệu ứng và rung, khoá ở ngày tương lai
- [ ] Tổng điểm ngày
- [ ] Điện thoại ngang: `NavigationRail`, header 1 dòng, 2 cột việc

### Giai đoạn 3: Màn Cả tuần và Dashboard
- [ ] Bảng tuần: cột tên cố định, cuộn ngang khi thiếu chỗ, cột ngày có màu, gạch chân ngày hôm nay
- [ ] Cột Total và dòng "Tổng điểm theo ngày"
- [ ] Dashboard cho `medium` trở lên: dọc thì xếp chồng, ngang thì thêm cột phụ

### Giai đoạn 4: Đổi thưởng và Thành tích
- [ ] Lưới phần thưởng, trạng thái "Cần thêm X điểm" và "Đổi ngay"
- [ ] Mã PIN 4 số: tạo (nhập 2 lần), kiểm tra, lưu hash
- [ ] Dialog xác nhận, nhập PIN, trừ điểm, confetti, lịch sử đổi
- [ ] Level và thanh tiến độ
- [ ] Streak card và chip ngày
- [ ] Ghi chú tuần theo từng bé (tự lưu khi gõ, debounce)

### Giai đoạn 5: Sửa danh sách
- [ ] Thêm/sửa/xoá (ẩn) việc, chọn emoji, kéo để sắp xếp
- [ ] Thêm/sửa/xoá phần thưởng
- [ ] Các bé: thêm (bắt buộc nhập tên), đổi tên, sắp xếp, xoá (popup xác nhận, không xoá được bé cuối cùng)
- [ ] Đổi mã PIN (nhập PIN cũ)
- [ ] (Tuỳ chọn) Dùng PIN khoá luôn màn Sửa danh sách

### Giai đoạn 6: Hoàn thiện và phát hành
- [ ] Kiểm tra layout trên đủ các cấu hình ở design-system mục 6.6 (phone, máy gập, tablet 7"/9"/10"+), cả dọc và ngang
- [ ] Gập/mở máy khi đang dùng app: không mất state, không overflow
- [ ] Kiểm tra chế độ tối, cỡ chữ lớn, TalkBack/VoiceOver
- [ ] Kiểm tra cả tiếng Việt và tiếng Anh: không còn chữ lẫn ngôn ngữ kia, chữ dài không bị cắt hay overflow
- [ ] Icon app và splash screen
- [ ] Widget test các màn chính, golden test cho component
- [ ] Ký bản release Android (keystore), cấu hình signing iOS
- [ ] Chuẩn bị store listing: ảnh chụp, mô tả, chính sách quyền riêng tư (app cho trẻ em: Google Play "Designed for Families", App Store Kids Category)

### Giai đoạn 7 (sau MVP)
- [ ] Đồng bộ nhiều máy (bố và mẹ) qua Firebase hoặc Supabase
- [ ] Nhắc việc bằng thông báo local (sáng/tối)
- [ ] Widget màn hình chính (điểm hôm nay)
- [ ] Avatar cho từng bé
- [ ] Xuất báo cáo tuần

## 9. Quyết định đã chốt (9/11/2026)

| # | Câu hỏi | Chốt |
|---|---|---|
| 1 | Có cho đánh sao ngày tương lai không? | Không. Chỉ hôm nay và các ngày đã qua. |
| 2 | Streak tính đủ 7/7 ngày trong cùng một tuần T2–CN, hay liên tiếp xuyên tuần? | Đủ 7/7 trong cùng một tuần T2–CN, như mẫu. |
| 3 | Đổi thưởng có cần bố mẹ xác nhận không? | Có, bằng mã PIN 4 số. |
| 4 | Ghi chú tuần riêng từng bé hay chung? | Riêng từng bé. |
| 5 | Số bé cố định 2 hay thêm/bớt được? | Thay đổi được ngay từ MVP: thêm bé (bắt buộc nhập tên), đổi tên, xoá bé (có popup xác nhận). |
| 6 | Đổi thưởng có làm tụt level không? | Không. |
| 7 | Ngôn ngữ giao diện? | Theo ngôn ngữ chọn trong app: tiếng Việt thì toàn bộ tiếng Việt, English thì toàn bộ tiếng Anh. |

Chi tiết tự chọn khi áp dụng các quyết định trên (đổi được nếu không hợp):
- Luôn còn ít nhất 1 bé. Xoá bé là xoá hẳn dữ liệu của bé, không ẩn.
- PIN tạo ở lần đổi thưởng đầu tiên. Đổi PIN phải nhập PIN cũ.
- Dữ liệu mặc định đổi theo ngôn ngữ cho tới khi bố mẹ tự sửa chữ.

## 10. Câu hỏi còn mở

1. Quên mã PIN thì làm sao? Đề xuất: nút "Quên mã PIN?" hỏi một phép nhân hai chữ số (bố mẹ làm được, bé nhỏ khó đoán), đúng thì cho đặt PIN mới.
2. Có dùng PIN khoá luôn màn **Sửa danh sách** không? Nếu không, bé có thể tự sửa điểm của việc hoặc xoá bé khác.
