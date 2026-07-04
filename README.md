# ManLab · P21 — Module Công bố / Thông báo năng lực Đo lường & Quan trắc môi trường

> Repo: `manlab-p21-test`

Module chuẩn hóa quy trình **ETV.MP 21** (Lần ban hành 02 · 26/06/2026) trên nền ManLab: quản lý toàn bộ vòng đời **công bố năng lực đo lường (NQ 66.18)** và **thông báo hoạt động dịch vụ quan trắc môi trường (NQ 66.19)** — từ lập hồ sơ → soát xét → phê duyệt & ký số → gửi cơ quan tiếp nhận → công khai → duy trì / điều chỉnh.

Đây là bản **standalone HTML một tệp** (`index.html`), chạy trực tiếp trên trình duyệt, không cần cài đặt. Dữ liệu demo lưu trên trình duyệt (localStorage).

## 🔗 Link test (GitHub Pages)

Sau khi bật GitHub Pages (xem `DEPLOY.md`), link sẽ có dạng:

```
https://<tài-khoản-github>.github.io/manlab-p21-test/
```

Gửi link này cho mọi người để test trực tiếp trên trình duyệt (máy tính hoặc điện thoại).

## 🔑 Đăng nhập (tài khoản demo)

Vai trò và quyền thao tác được xác định theo tài khoản ManLab. Khi chưa kết nối được API ManLab thật, dùng các tài khoản demo sau (mật khẩu đều là `123`):

| Tài khoản | Mật khẩu | Vai trò |
|-----------|----------|---------|
| `nth` | `123` | Người thực hiện |
| `ldp` | `123` | Lãnh đạo phòng |
| `ldv` | `123` | Lãnh đạo Viện |
| `admin` | `123` | Super Admin (chỉ cấu hình) |

> Có thể bấm thẳng vào các nút tài khoản demo ở màn hình đăng nhập.

## 🧭 Luồng nghiệp vụ (chuỗi duyệt)

1. **Người thực hiện** lập hồ sơ → thêm đối tượng từ *Danh mục Phương tiện đo* → **Gửi soát xét**.
2. **Lãnh đạo phòng** soát xét → **Duyệt soát xét · Đề nghị Lãnh đạo Viện duyệt** (hoặc *Trả lại bổ sung*).
3. **Lãnh đạo Viện** **Phê duyệt nội bộ & ký số** (hoặc *Trả lại soát xét*) → hồ sơ khóa dữ liệu 🔒.
4. **Lãnh đạo phòng** **Gửi cơ quan tiếp nhận** → **Ghi nhận biên nhận**.
5. **Công khai & sinh QR** → trạng thái *Còn hiệu lực* (mới được dùng trong báo giá, hợp đồng, chứng chỉ, phiếu kết quả, báo cáo).
6. Duy trì: **Điều chỉnh** (tạo phiên bản mới, không ghi đè), *Tạm dừng*, *Hủy bỏ*, *Hết hiệu lực*; QTMT nộp **Báo cáo hằng năm (Mẫu 9.02)**.

## ✨ Tính năng chính

- Hai loại hồ sơ: **Đo lường (Mẫu 01)** và **Quan trắc môi trường (Mẫu 9.01)**.
- **Chọn đối tượng từ Danh mục Phương tiện đo** (link-only): tích chọn từng dòng / **chọn tất cả** / **thêm hàng loạt**; tự kiểm tra cổng **G1–G7**, ẩn/cảnh báo PTĐ chưa đủ điều kiện.
- Nút **Cập nhật từ ManLab** (khai báo API `GET /api/phuong-tien-do`) — lấy danh mục sống khi triển khai trong hạ tầng ManLab; fallback dữ liệu nhúng khi chạy standalone.
- Kiểm soát **quy tắc nghiệp vụ BR1–BR11** theo thời gian thực; kiểm tra **trường bắt buộc (Mục 8.2)**.
- **Bằng chứng** đính kèm ảnh chụp màn hình / tài liệu (PDF, Word, Excel).
- Xuất **Bản công bố Mẫu 01 / Thông báo Mẫu 9.01** in đúng khổ **A4 dọc**; **Trang công khai** kèm **mã QR tra cứu (BR4)**.
- **Phiên bản** (điều chỉnh không ghi đè), **Nhật ký thao tác** (truy xuất nguồn gốc BR7), **Báo cáo hằng năm (Mẫu 9.02)** cho QTMT.
- **Hướng dẫn sử dụng** tích hợp ngay trong ứng dụng.

## ⚙️ Tích hợp ManLab thật (khi triển khai)

Các điểm tích hợp API đã được khai báo sẵn trong `index.html` (biến `MANLAB`):

| Chức năng | Phương thức | Đường dẫn |
|-----------|-------------|-----------|
| Đăng nhập | `POST` | `https://manlab.etv.org.vn/api/auth/login` |
| Danh mục PTĐ | `GET` (Bearer token) | `https://manlab.etv.org.vn/api/phuong-tien-do` |

Khi API trả về đúng định dạng, ứng dụng dùng dữ liệu sống; nếu không kết nối được (CORS/mạng) sẽ tự chuyển sang chế độ demo + dữ liệu nhúng và báo rõ trạng thái.

## 📄 Cấu trúc thư mục

```
manlab-p21-test/
├── index.html     # Toàn bộ ứng dụng (một tệp)
├── deploy.sh      # Script đẩy lên GitHub + bật Pages (macOS/Linux)
├── deploy.ps1     # Script tương đương cho Windows (PowerShell)
├── README.md      # Tài liệu này
└── DEPLOY.md      # Hướng dẫn đẩy lên GitHub + bật link test (GitHub Pages)
```

## 📌 Ghi chú

- Dữ liệu demo lưu bằng `localStorage` trên trình duyệt của mỗi người test; xóa dữ liệu trình duyệt sẽ mất dữ liệu demo.
- Bản chính thức lưu tập trung trên ManLab.
- Cơ chế tự công bố / thông báo áp dụng đến **28/02/2027** (BR8).

---

© Viện Kiểm định Công nghệ và Môi trường (ETV) · ManLab · Menu P21
