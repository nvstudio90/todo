# ToDo

App Flutter (Android + iOS).

## Conventions

### Comments

Adopted from `newpaint` (09/11/2026).
**This rule beats the existing comment style in any file it meets.**

Viết comment NGẮN GỌN. Tối đa **3 dòng** comment cho một function. Không giải
thích dài dòng, không kể lại lịch sử thay đổi, không dựng mục `##` trong
docblock.

**Why:** comment dài trôi khỏi code nhanh hơn code, và làm loãng chính cái dòng
đáng đọc.

**How to apply:**
- Nói **vì sao**, không mô tả **cái gì** — cái gì thì code đã nói.
- Ưu tiên code tự giải thích bằng tên rõ ràng hơn là dùng comment. Không comment
  code đã hiển nhiên. Chỉ comment cho logic không hiển nhiên, ràng buộc quan
  trọng, workaround, hành vi đặc thù nền tảng, hoặc quyết định không diễn đạt
  được qua tên và cấu trúc.
- Comment nào thực sự cần thì giữ ngắn — tối đa **3 dòng**.
- Bỏ khỏi comment: lịch sử ("trước đây…", "commit X đã đổi…"), số đo, tên ticket,
  mục `##` trong docblock. Những thứ đó thuộc về commit message và MR
  description.
- Sửa một dòng trong comment cũ ⇒ dòng đó phải theo luật mới, dù phần còn lại
  của comment cũ vi phạm.
- **Không đi sửa comment cũ** ngoài dòng mình đụng, trừ khi được bảo.
- Áp dụng NGAY lúc viết file mới: docblock đầu file mới cũng tối đa 3 dòng.

**Bước bắt buộc trước khi báo xong:** `git add -N <file mới>` (không thì
`git diff` bỏ sót file untracked), rồi soát từng dòng comment mình thêm:

```bash
git diff -U0 | grep '^+' | grep -E '//|/\*|^\+\s*\*'
```

### Layout UI

Mọi layout/màn hình UI mới hoặc sửa phải chạy đúng trên **cả ngang lẫn dọc** và
trên **mọi nhóm thiết bị** dưới đây, không được chỉ tối ưu cho một máy.

| Nhóm | Breakpoint gợi ý (`MediaQuery.sizeOf(context).shortestSide`) |
|---|---|
| Mobile compact | `< 600` |
| Fold (gập / mở) | cả màn ngoài hẹp lẫn màn trong gần vuông; đừng giả định tỉ lệ |
| Tablet 7" | `>= 600` |
| Tablet 8–9" | `>= 720` |
| Tablet >= 10" | `>= 800` (xét thêm chiều cao nếu cần) |

Mỗi nhóm × 2 hướng (`Orientation.landscape` / `portrait`) = phải có kết quả đúng.

**Why:** app chạy trên phone, fold và tablet; layout chỉ vừa một máy thường vỡ
(cắt chữ, chồng widget, overflow, khoảng trống lớn) ở máy còn lại.

**How to apply:**
- Dùng `LayoutBuilder` / `MediaQuery.sizeOf`, `Expanded` / `Flexible`,
  `ConstrainedBox(maxWidth: …)`; không hard-code width/height cho container
  chính.
- Breakpoint, spacing, font size, số cột grid gom vào một chỗ dùng chung và tra
  theo `shortestSide` + orientation; không nhân bản cả màn khi chỉ khác số.
- Chỉ tách widget layout riêng (compact ↔ wide) khi **cấu trúc** khác (list ↔
  master-detail, bottom sheet ↔ side panel); phần còn lại dùng chung.
- Nội dung cuộn được (`ListView`, `SingleChildScrollView`, `CustomScrollView`)
  khi màn thấp; không để nút quan trọng bị đẩy ra ngoài màn ở landscape phone,
  không để lỗi overflow.
- Tablet: giới hạn bề ngang nội dung (sheet, dialog, form) thay vì kéo giãn hết
  màn; tôn trọng `SafeArea`, cutout và bàn phím (`MediaQuery.viewInsetsOf`).
- Không chốt theo tên thiết bị hay `Platform.isX`; dùng kích thước và
  orientation. Fold phải chịu được đổi kích thước khi gập/mở giữa chừng (không
  mất state).

**Bước bắt buộc trước khi báo xong:** kiểm tra layout mới ở tối thiểu: phone
dọc + ngang, fold, tablet 7"/9" và >= 10" (Android emulator + `adb shell wm
size`/`wm density`, hoặc iOS Simulator iPhone / iPad mini / iPad Pro, xoay cả
hai hướng). Nêu rõ trong báo cáo cấu hình nào đã kiểm, cấu hình nào chưa.
