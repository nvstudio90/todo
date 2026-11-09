# Design system: Bảng việc của các bé

Tài liệu này mô tả giao diện app, lấy theo mẫu thiết kế
[Bảng việc của các bé](https://claude.ai/artifact/4Swq87kD26qksGpWUwru3P).
Ảnh chụp mẫu nằm trong [design/reference](design/reference).

> Mã màu được đo từ ảnh chụp màn hình, không phải từ CSS gốc, nên có thể lệch vài đơn vị.
> Trước khi chốt, đặt app cạnh ảnh mẫu để so lại.

## 1. Tinh thần thiết kế

- **Vui, mềm, thân thiện với trẻ em:** font tròn, emoji cho từng việc, ngôi sao vàng làm phần thưởng.
- **Màu pastel theo từng ngày:** mỗi cột ngày (T2 → CN) có một màu nền nhạt riêng, tạo hiệu ứng cầu vồng.
- **Phân vùng bằng màu:** việc **bắt buộc** dùng màu hồng, việc **tự chọn** màu xanh lá, **điểm** màu vàng, **level/streak** màu tím.
- **Hai chế độ sáng và tối**, chạy theo cài đặt của máy.
- **Chữ tiếng Việt và tiếng Anh xen kẽ** như trong mẫu, ví dụ "Must-Do Tasks (Bắt buộc)", "My Points Today".

## 2. Màu sắc

### 2.1 Màu nền và chữ

| Token | Sáng | Tối | Dùng cho |
|---|---|---|---|
| `background` | `#F2F6FF` | `#121421` | Nền màn hình |
| `surface` | `#FFFFFF` | `#1D1F2D` | Thẻ (card), header |
| `surfaceAlt` | `#FBFAFF` | `#202230` | Dòng việc trong bảng |
| `surfaceInset` | `#F6F6FA` | `#181A27` | Ô "Cần thêm X điểm", ô input |
| `border` | `#E6E8F2` | `#2A2C3C` | Viền thẻ, đường kẻ dòng |
| `textPrimary` | `#2A2438` | `#E8E6F2` | Tên việc, số điểm lớn |
| `textSecondary` | `#6B6B7B` | `#A9A8BA` | Mô tả, nhãn phụ |
| `textMuted` | `#A8A8B3` | `#6E6E80` | Level chưa đạt, dấu "–" |

### 2.2 Màu thương hiệu

| Token | Sáng | Tối | Dùng cho |
|---|---|---|---|
| `primary` | `#7B4FD6` | `#B29DF5` | Chip bé đang chọn, thanh tiến độ, ngày hôm nay |
| `onPrimary` | `#FFFFFF` | `#1D1F2D` | Chữ trên chip đang chọn |
| `primarySoft` | `#EEE8FE` | `#2B2447` | Level hiện tại, thẻ Streak, nền thanh tiến độ |
| `star` | `#F5B800` | `#F5B800` | Ngôi sao đã đánh dấu |
| `starEmpty` | `#C0C8D0` | `#505068` | Ngôi sao chưa đánh dấu (chỉ có viền) |

**Chữ "My To-Do List" nhiều màu:**

| Phần | Sáng | Tối |
|---|---|---|
| "My" và "List" | `#7B4FD6` | `#B49CFA` |
| "To" | `#F0901E` | `#F7931E` |
| "-" | `#3FA36B` | `#4CB87D` |
| "Do" | `#3A7BE0` | `#4A84E6` |

Dấu "•" giữa "Be kind • Try your best • Have fun!" dùng màu hồng `#D04070`.

### 2.3 Màu theo khu vực

| Khu vực | Token | Sáng | Tối |
|---|---|---|---|
| Việc bắt buộc | `mustDoBg` (header, cột Point) | `#FDE8EF` | `#36212C` |
| | `mustDoBorder` | `#F6C3D3` | `#4A2A3A` |
| | `mustDoText` (tiêu đề, "+2") | `#C8406E` | `#E28AAA` |
| Việc tự chọn | `optionalBg` | `#EAF4E3` | `#1E3022` |
| | `optionalBorder` | `#C9E3BE` | `#2C4A30` |
| | `optionalText` | `#4E8A45` | `#9FCB96` |
| Điểm hôm nay | `pointsBg` | `#FEF5D5` | `#3A3120` |
| Đổi thưởng | `rewardBg` | `#FDE8EF` | `#36212A` |
| | `rewardText` | `#C8406E` | `#E088A8` |
| Streak | `streakBg` | `#EEE8FE` | `#2B2448` |
| | `streakText` | `#6E4FC4` | `#A99CE0` |
| Ghi chú | `notesBg` | `#FEF5D5` | `#3A3120` |

### 2.4 Màu cột ngày (cầu vồng pastel)

| Ngày | Sáng | Tối |
|---|---|---|
| T2 (Mon) | `#EEF4FF` | `#22263A` |
| T3 (Tue) | `#EAF9F7` | `#1F2A32` |
| T4 (Wed) | `#FFF6E0` | `#2C2C2A` |
| T5 (Thu) | `#F6EEFF` | `#24253D` |
| T6 (Fri) | `#EEF8EE` | `#202B2A` |
| T7 (Sat) | `#FFF2E4` | `#2E2727` |
| CN (Sun) | `#FDEEF4` | `#2C2333` |

Ngày hôm nay có tên ngày tô màu `primary` và một gạch chân `primary` dày 2px dưới tiêu đề cột.

## 3. Font chữ

Nhìn từ mẫu, có hai họ font, cả hai đều hỗ trợ tiếng Việt:

| Vai trò | Font | Ghi chú |
|---|---|---|
| Display (tiêu đề, số điểm, tên level) | **Baloo 2** (ExtraBold 800 / Bold 700) | Chữ tròn, mập |
| Body (nội dung, nhãn, nút) | **Be Vietnam Pro** (Regular 400 / Medium 500 / SemiBold 600) | Dễ đọc trên điện thoại |

Đóng gói font vào `assets/fonts/` để app chạy offline, không tải qua mạng.

| Token | Font | Cỡ / dòng | Độ đậm | Ví dụ |
|---|---|---|---|---|
| `displayLarge` | Baloo 2 | 36 / 40 | 800 | "My To-Do List" |
| `displayNumber` | Baloo 2 | 40 / 44 | 800 | Số điểm hôm nay "7" |
| `titleLarge` | Baloo 2 | 22 / 28 | 800 | "Must-Do Tasks", "Đổi thưởng" |
| `titleMedium` | Baloo 2 | 18 / 24 | 700 | "My Points Today", "My Levels", "20 ⭐" |
| `bodyLarge` | Be Vietnam Pro | 16 / 22 | 500 | Tên việc |
| `bodyMedium` | Be Vietnam Pro | 14 / 20 | 400 | Mô tả phần thưởng, ghi chú |
| `labelLarge` | Be Vietnam Pro | 14 / 20 | 700 | Chip "Bé 1", nút, "+2" |
| `labelSmall` | Be Vietnam Pro | 12 / 16 | 500 | "Tuần này", "T2", "(0–49đ)" |

## 4. Khoảng cách, bo góc, đổ bóng

**Khoảng cách** (bội số của 4): `4, 8, 12, 16, 20, 24, 32`.
- Lề màn hình: 16
- Khoảng giữa các thẻ: 16
- Padding trong thẻ: 16 (điện thoại), 20 (tablet)
- Chiều cao dòng việc: tối thiểu 56. Vùng bấm ngôi sao tối thiểu 44×44 để trẻ dễ bấm.

**Bo góc:**

| Token | Giá trị | Dùng cho |
|---|---|---|
| `radiusSm` | 8 | Chip ngày T2…CN, ô input |
| `radiusMd` | 12 | Ô "Cần thêm X điểm", nút chuyển tuần, nút |
| `radiusLg` | 16 | Thẻ phần thưởng, ô level |
| `radiusXl` | 20 | Thẻ lớn (header, bảng việc, điểm, đổi thưởng) |
| `radiusPill` | 999 | Chip "Bé 1 / Bé 2", thanh tiến độ |

**Viền và bóng:** thiết kế phẳng, chủ yếu dùng viền.
- Thẻ thường: viền 1px `border`.
- Thẻ việc bắt buộc / tự chọn / đổi thưởng: viền 1.5px theo màu khu vực.
- Bóng: chỉ dùng ở chế độ sáng, rất nhẹ: `0 1px 2px rgba(42,36,56,0.06)`. Chế độ tối không dùng bóng.

## 5. Thành phần (component)

### 5.1 Header
- Thẻ `surface`, góc `radiusXl`.
- Gồm: tiêu đề nhiều màu, dòng slogan "Be kind • Try your best • Have fun!", nhóm chip chọn bé và bộ chuyển tuần `‹ 9/11 – 15/11/2026 ›`.
- Trên điện thoại, bộ chuyển tuần xuống một dòng riêng dưới chip chọn bé.

### 5.2 Chip chọn bé (`KidChip`)
- Hình viên thuốc, cao 40, padding ngang 20, font `labelLarge`.
- Đang chọn: nền `primary`, chữ `onPrimary`.
- Chưa chọn: nền `primarySoft` nhạt (sáng `#F6F4FF`, tối `#10131B`), viền 1px `border`, chữ `textPrimary`.

### 5.3 Bộ chuyển tuần (`WeekSwitcher`)
- Hai nút vuông 32×32 (`‹`, `›`), nền `surface`, viền `border`, góc `radiusMd`.
- Ở giữa là khoảng ngày `d/M – d/M/yyyy`, font `labelLarge`.

### 5.4 Thẻ điểm (`PointsCard`)
- Nền `pointsBg`, góc `radiusXl`.
- Tiêu đề "My Points Today", sau đó là ⭐ và số điểm lớn (`displayNumber`).
- Ba dòng nhãn và giá trị: **Tuần này**, **Tổng đã tích**, **Còn lại để đổi** (giá trị căn phải, đậm).

### 5.5 Banner thông tin
- Nền `surface`, viền `border`, góc `radiusMd`, chữ `bodyMedium` màu `textSecondary`.
- Mẫu: "Bản offline: dữ liệu chỉ lưu trong trình duyệt trên máy này." Trong app nên đổi thành "Dữ liệu được lưu trên máy này."

### 5.6 Bảng việc (`TaskSection`), dạng tuần
- Thẻ có viền màu khu vực. Header có nền màu khu vực, gồm ⭐ + tiêu đề `titleLarge` màu khu vực và phụ đề "(Bắt buộc)" / "(Tự chọn)" cỡ nhỏ hơn.
- Các cột: **Tên việc** (emoji + chữ) | **Point** (nền màu khu vực, "+2" đậm màu khu vực) | **T2 … CN** (mỗi cột một màu pastel, ô có ngôi sao) | **Total Điểm**.
- Dòng cuối "Tổng điểm theo ngày": tổng điểm từng ngày, ngày chưa có điểm hiện "–".
- Chế độ sửa: mỗi dòng có thêm nút `×` để xoá. Cuối bảng có dòng thêm việc: [nút chọn emoji] [ô "Thêm việc tự chọn..."] [ô điểm, mặc định 2] [nút **Thêm** màu khu vực].

### 5.7 Ngôi sao (`StarToggle`)
- Chưa đánh dấu: ngôi sao rỗng, viền 1.5px `starEmpty`, cỡ 22.
- Đã đánh dấu: ngôi sao đặc `star`, cỡ 24.
- Khi bấm: phóng to 1 → 1.3 → 1 (khoảng 250ms, `Curves.easeOutBack`), rung nhẹ (haptic light), hiện "+2" bay lên rồi mờ dần. Cộng điểm có hiệu ứng số chạy.

### 5.8 Thẻ phần thưởng (`RewardCard`)
- Nền `surface`, góc `radiusLg`, padding 12.
- Dòng đầu: giá "20 ⭐" (`titleMedium`) và emoji lớn (32) bên phải.
- Mô tả: `bodyMedium`, `textSecondary`.
- Nút dưới cùng (rộng hết thẻ, nền `surfaceInset`, góc `radiusMd`):
  - Chưa đủ điểm: "Cần thêm X điểm", chữ `textMuted`, không bấm được.
  - Đủ điểm: "Đổi ngay" (mẫu chưa có trạng thái này), nền `rewardText`, chữ trắng.
- Header khu đổi thưởng: "🎁 Đổi thưởng" và bên phải "Còn X điểm".

### 5.9 Level (`LevelTrack`)
- Bốn ô level nối với nhau bằng mũi tên "→": emoji (🌱 🌿 🪴 🌳), "Level N" đậm, tên tiếng Anh, khoảng điểm.
- Level hiện tại có nền `primarySoft` và chữ `textPrimary`. Level chưa đạt dùng chữ `textMuted`.
- Bên dưới là thanh tiến độ cao 8, nền `primarySoft`, phần đã đạt màu `primary`, bo tròn.
- Dòng mô tả: "Bé 1 có 12 điểm. Còn 38 điểm nữa để lên Level 2 (Super Helper)."

### 5.10 Streak (`StreakCard`)
- Nền `streakBg`. Tiêu đề "🔥 Streak Bonus" và mô tả "Hoàn thành các task bắt buộc 7 ngày liên tiếp trong tuần → **+10 điểm!**"
- Bảy chip ngày T2…CN (nền `surface`, góc `radiusSm`). Ngày đã làm hết việc bắt buộc có nền `primary` và chữ trắng.
- Dòng tiến độ "0/7 ngày đã xong hết việc bắt buộc.", màu `streakText`, đậm.

### 5.11 Ghi chú (`NotesCard`)
- Nền `notesBg`. Tiêu đề "✏️ Notes", ô nhập nhiều dòng có kẻ dòng như giấy vở (đường kẻ 1px, mờ 15%).
- Gợi ý: "Ghi chú của bố mẹ cho tuần này..."

### 5.12 Nút phụ
- "Sửa danh sách việc": nền `surface`, viền `border`, góc `radiusMd`, chữ `labelLarge`.

## 6. Chuyển mẫu web sang điện thoại

Mẫu là trang web, bảng 7 cột ngày không vừa màn hình điện thoại (phải cuộn ngang).
App giữ nguyên ngôn ngữ thiết kế nhưng sắp lại bố cục cho điện thoại.

| Kích thước | Bố cục |
|---|---|
| **Điện thoại** (< 600dp) | Thanh tab dưới, 4 tab (xem [app-plan.md](app-plan.md)). Màn **Hôm nay** dùng **thanh chọn ngày** T2…CN (mỗi chip mang màu pastel của ngày) và danh sách việc dạng thẻ, mỗi việc một dòng với **một** ngôi sao lớn. Bảng tuần đầy đủ nằm ở tab **Cả tuần**: cột tên việc cố định bên trái, cuộn ngang phần ngày. |
| **Tablet** (≥ 600dp) | Giống mẫu web: bảng tuần ở cột chính, cột phụ bên phải chứa Điểm và Đổi thưởng. Level, Streak và Ghi chú xếp thành hàng ba thẻ ở cuối. |

## 7. Ánh xạ sang Flutter

- Dùng `ThemeData` của Material 3 với `ColorScheme` tự đặt (`primary`, `surface`, …), không sinh màu từ `fromSeed`.
- Các màu riêng (khu vực, cột ngày, sao) đặt trong `ThemeExtension<AppColors>`, có `lerp` để đổi theo chế độ sáng/tối.
- Bo góc và khoảng cách đặt trong `abstract final class AppRadius` / `AppSpacing`.
- Font: khai báo trong `pubspec.yaml` (assets), `TextTheme` riêng theo bảng ở mục 3.
- Emoji: dùng emoji hệ thống (`Text('🛏️')`). Nếu muốn giống nhau trên iOS và Android, cân nhắc gói font Noto Color Emoji.
- Vị trí đề xuất: `lib/core/theme/app_theme.dart`, `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`.
