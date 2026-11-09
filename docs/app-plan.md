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
| F1 | Hồ sơ bé | Mặc định 2 bé ("Bé 1", "Bé 2"), đổi tên được. Các bé **dùng chung danh sách việc**, nhưng **mỗi bé có bảng sao và điểm riêng**. |
| F2 | Tuần | Tuần chạy từ T2 đến CN. Có nút chuyển tuần trước/sau, hiển thị dạng `9/11 – 15/11/2026`. |
| F3 | Việc bắt buộc | Danh sách việc hằng ngày, mỗi việc có emoji, tên và điểm (+2, +3). |
| F4 | Việc tự chọn | Danh sách việc khuyến khích, mỗi việc có emoji, tên và điểm (+2 → +5). |
| F5 | Đánh dấu sao | Bấm ngôi sao ở ô (việc × ngày) để bật/tắt "đã làm" và cộng/trừ điểm. |
| F6 | Tổng điểm | Tổng theo từng việc trong tuần (cột Total), tổng theo ngày (dòng cuối bảng). |
| F7 | Điểm của tôi | Điểm hôm nay, tuần này, tổng đã tích, còn lại để đổi. |
| F8 | Đổi thưởng | Danh sách phần thưởng theo giá sao. Chưa đủ thì hiện "Cần thêm X điểm", đủ thì cho đổi và trừ điểm. |
| F9 | Level | 4 level tính theo **tổng đã tích**, có thanh tiến độ và câu "Còn X điểm nữa để lên Level N". |
| F10 | Streak bonus | Làm hết việc bắt buộc đủ 7/7 ngày trong tuần thì được +10 điểm. Hiển thị chip T2…CN và tiến độ "x/7". |
| F11 | Ghi chú tuần | Ô ghi chú của bố mẹ cho từng tuần. |
| F12 | Sửa danh sách | Thêm/xoá việc (emoji, tên, điểm) và đổi tên bé. |

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
- Mẫu web tính level theo tổng đã tích, nên đổi thưởng **không làm tụt level**.

## 4. Dữ liệu mặc định (lấy từ mẫu)

**Việc bắt buộc**

| Emoji | Việc | Điểm |
|---|---|---|
| 🛏️ | Tự gấp chăn/gọn giường sau khi ngủ dậy | 2 |
| 🪥 | Đánh răng sáng + tối | 2 |
| 👕 | Tự mặc quần áo và bỏ đồ bẩn đúng chỗ | 2 |
| 🎒 | Chuẩn bị cặp sách/đồ đi học | 2 |
| 🍴 | Ăn uống gọn gàng, không cần nhắc nhiều | 2 |
| 🧸 | Dọn đồ chơi sau khi chơi | 2 |
| 📚 | Hoàn thành bài tập/việc học trong ngày | 3 |
| 🚿 | Tắm rửa, thay đồ, chuẩn bị đi ngủ | 2 |

**Việc tự chọn**

| Emoji | Việc | Điểm |
|---|---|---|
| 📖 | Đọc sách 15–20 phút | 3 |
| 🧹 | Chủ động giúp một việc nhà | 3 |
| 🧺 | Gấp/cất quần áo | 2 |
| 🪴 | Tưới cây/chăm cây | 2 |
| 🎨 | Vẽ, làm thủ công hoặc hoạt động sáng tạo | 2 |
| 👟 | Vận động ngoài trời ≥30 phút | 3 |
| 🇬🇧 | Học tiếng Anh thêm 15 phút | 2 |
| 💡 | Học một điều mới và kể lại cho bố mẹ | 3 |
| ❤️ | Tự làm một việc tốt mà không cần bố mẹ nhắc | 5 |

**Phần thưởng**

| Giá | Emoji | Phần thưởng |
|---|---|---|
| 20 | 🍦 | Chọn món tráng miệng yêu thích |
| 30 | 🎬 | Chọn phim xem cùng gia đình |
| 40 | 🎲 | Chọn trò chơi gia đình |
| 50 | 🚗 | Được chọn địa điểm đi chơi cuối tuần |
| 70 | 🎁 | Một món đồ nhỏ bé thích |
| 100 | 🎡 | Một trải nghiệm đặc biệt: đi chơi, workshop, khu vui chơi… |

**Level**

| Level | Emoji | Tên | Điểm |
|---|---|---|---|
| 1 | 🌱 | Little Helper | 0–49 |
| 2 | 🌿 | Super Helper | 50–99 |
| 3 | 🪴 | Family Hero | 100–149 |
| 4 | 🌳 | Independent Kid | 150+ |

## 5. Màn hình (điện thoại)

Điều hướng bằng thanh tab dưới. Header (tiêu đề, chip chọn bé, chuyển tuần) dùng chung cho các tab.

| Tab | Nội dung |
|---|---|
| **Hôm nay** | Thẻ điểm (F7). Thanh chọn ngày T2…CN, mặc định là hôm nay. Danh sách việc bắt buộc rồi tự chọn của ngày đang chọn, mỗi dòng có emoji, tên, "+điểm" và một ngôi sao lớn. Cuối danh sách là tổng điểm ngày. |
| **Cả tuần** | Bảng tuần như mẫu web (F6): cột tên việc cố định, cuộn ngang các cột ngày và Total. |
| **Đổi thưởng** | "Còn X điểm", lưới 2 cột thẻ phần thưởng (F8), lịch sử đã đổi. |
| **Thành tích** | Level (F9), Streak (F10), Ghi chú tuần (F11). |

Màn phụ:
- **Sửa danh sách** (mở từ nút ✏️ trên header): hai tab Bắt buộc / Tự chọn, kéo để sắp xếp, thêm/sửa/xoá việc (bottom sheet gồm chọn emoji, tên, điểm). Có thêm mục Phần thưởng và mục Tên các bé.
- **Xác nhận đổi thưởng**: dialog "Đổi 20 ⭐ lấy 'Chọn món tráng miệng yêu thích'?", đổi xong bắn confetti.

Trên tablet (≥ 600dp), bố cục giống mẫu web: bảng tuần cùng cột phụ chứa Điểm và Đổi thưởng.

## 6. Kiến trúc

| Hạng mục | Lựa chọn | Lý do |
|---|---|---|
| Quản lý state | `flutter_riverpod` | Dễ test, tách logic khỏi UI, hợp với stream từ DB |
| Lưu trữ local | `drift` (SQLite) | Dữ liệu có quan hệ (bé × việc × ngày), dễ truy vấn tổng điểm, có migration |
| Điều hướng | `go_router` (`StatefulShellRoute` cho tab dưới) | Giữ state từng tab, sau này dễ thêm deep link |
| Ngày/giờ, i18n | `intl` | Định dạng ngày kiểu Việt Nam, tính tuần T2–CN |
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
  features/                    # widget test
```

## 7. Mô hình dữ liệu (bảng drift)

| Bảng | Cột chính |
|---|---|
| `kids` | `id`, `name`, `sortOrder`, `createdAt` |
| `tasks` | `id`, `emoji`, `title`, `points`, `type` (`mustDo` / `optional`), `sortOrder`, `createdAt`, `archivedAt?` |
| `completions` | `id`, `kidId`, `taskId`, `date` (yyyy-MM-dd), `points` (lưu lúc đánh sao), `createdAt`. Khoá duy nhất: (`kidId`, `taskId`, `date`) |
| `rewards` | `id`, `emoji`, `title`, `cost`, `sortOrder`, `archivedAt?` |
| `redemptions` | `id`, `kidId`, `rewardId`, `cost` (lưu lúc đổi), `redeemedAt` |
| `week_notes` | `kidId`, `weekStart` (ngày T2), `text`, `updatedAt` |

Streak bonus **không lưu**, mà tính từ `completions` và `tasks`. Cách này tránh sai lệch khi bỏ sao.

## 8. Lộ trình

### Giai đoạn 0: Nền tảng
- [x] Khởi tạo project Flutter (Android, iOS)
- [x] Đổi app id sang `com.nvstudio.todo`
- [ ] Thêm dependency (riverpod, drift, go_router, intl, flutter_animate, confetti)
- [ ] Bật lint chặt hơn (`very_good_analysis` hoặc tự cấu hình)
- [ ] Thêm font vào assets, dựng `AppTheme` sáng/tối theo [design-system.md](design-system.md)
- [ ] Màn "gallery" nội bộ để xem các component

### Giai đoạn 1: Dữ liệu và luật tính điểm
- [ ] Schema drift, migration v1, seed dữ liệu mặc định (mục 4)
- [ ] Các repository
- [ ] `scoring/`: `pointsOn`, `weekPoints`, `streak`, `totalEarned`, `available`, `level`
- [ ] Unit test đủ các trường hợp biên: tuần qua tháng/năm, bỏ sao, việc bị ẩn giữa tuần, sửa điểm việc

### Giai đoạn 2: Màn Hôm nay
- [ ] Header: tiêu đề nhiều màu, `KidChip`, `WeekSwitcher`
- [ ] `PointsCard`
- [ ] Thanh chọn ngày T2…CN với màu pastel
- [ ] Danh sách việc bắt buộc và tự chọn, `StarToggle` có hiệu ứng và rung
- [ ] Tổng điểm ngày

### Giai đoạn 3: Màn Cả tuần
- [ ] Bảng tuần: cột tên cố định, cuộn ngang, cột ngày có màu, gạch chân ngày hôm nay
- [ ] Cột Total và dòng "Tổng điểm theo ngày"
- [ ] Bố cục tablet giống mẫu web

### Giai đoạn 4: Đổi thưởng và Thành tích
- [ ] Lưới phần thưởng, trạng thái "Cần thêm X điểm" và "Đổi ngay"
- [ ] Dialog xác nhận, trừ điểm, confetti, lịch sử đổi
- [ ] Level và thanh tiến độ
- [ ] Streak card và chip ngày
- [ ] Ghi chú tuần (tự lưu khi gõ, debounce)

### Giai đoạn 5: Sửa danh sách
- [ ] Thêm/sửa/xoá (ẩn) việc, chọn emoji, kéo để sắp xếp
- [ ] Thêm/sửa/xoá phần thưởng
- [ ] Đổi tên bé
- [ ] (Tuỳ chọn) Khoá phụ huynh bằng mã PIN 4 số

### Giai đoạn 6: Hoàn thiện và phát hành
- [ ] Kiểm tra chế độ tối, cỡ chữ lớn, TalkBack/VoiceOver
- [ ] Icon app và splash screen
- [ ] Widget test các màn chính, golden test cho component
- [ ] Ký bản release Android (keystore), cấu hình signing iOS
- [ ] Chuẩn bị store listing: ảnh chụp, mô tả, chính sách quyền riêng tư (app cho trẻ em: Google Play "Designed for Families", App Store Kids Category)

### Giai đoạn 7 (sau MVP)
- [ ] Đồng bộ nhiều máy (bố và mẹ) qua Firebase hoặc Supabase
- [ ] Nhắc việc bằng thông báo local (sáng/tối)
- [ ] Widget màn hình chính (điểm hôm nay)
- [ ] Hơn 2 bé, avatar cho từng bé
- [ ] Xuất báo cáo tuần

## 9. Câu hỏi cần chốt

1. Có cho đánh sao **ngày tương lai** không? Đề xuất: chỉ cho ngày hôm nay và các ngày đã qua.
2. Streak có phải **đủ 7/7 ngày trong cùng một tuần T2–CN** như mẫu, hay tính liên tiếp xuyên tuần?
3. Đổi thưởng có cần **bố mẹ xác nhận** (PIN) không?
4. Ghi chú tuần là **riêng từng bé** hay **chung**?
5. Số bé có cố định 2 không, hay cho thêm/bớt ngay từ MVP?
6. Đổi thưởng có làm **tụt level** không? Đề xuất: không, vì level tính theo tổng đã tích.
7. Ngôn ngữ giao diện: giữ kiểu Việt và Anh xen kẽ như mẫu, hay chuyển hết sang tiếng Việt?
