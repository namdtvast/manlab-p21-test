# Hướng dẫn đẩy lên GitHub và tạo link test (GitHub Pages)

Mục tiêu: đưa thư mục `manlab-p21-test` lên GitHub và bật GitHub Pages để có **link công khai** gửi mọi người test trên trình duyệt.

---

## ⚡ Cách nhanh nhất — chạy 1 lệnh trong terminal (khuyến nghị)

Có sẵn script tự động: tạo repo, đẩy code, bật Pages và in ra link test.

**macOS / Linux:**
```bash
cd manlab-p21-test          # thư mục chứa index.html
chmod +x deploy.sh
./deploy.sh                 # repo mặc định "manlab-p21-test", public
# ./deploy.sh ten-repo-khac        # đổi tên repo
# ./deploy.sh manlab-p21-test private       # tạo repo private
```

**Windows (PowerShell):**
```powershell
cd manlab-p21-test
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass   # cho phép chạy script phiên này
.\deploy.ps1
```

Yêu cầu: đã cài **git**. Nếu có **GitHub CLI (`gh`)**, script chạy tự động hoàn toàn (kể cả tạo repo + bật Pages). Nếu chưa có `gh`, cài nhanh:
- macOS: `brew install gh`
- Windows: `winget install --id GitHub.cli`
- Linux: xem https://github.com/cli/cli#installation

Lần đầu, `gh` sẽ hỏi đăng nhập GitHub (mở trình duyệt xác thực). Sau khi xong, script in ra link:
```
https://<tài-khoản-github>.github.io/manlab-p21-test/
```

> Nếu không muốn dùng script, làm thủ công theo Cách A hoặc B bên dưới.

---

## Cách A — Không dùng dòng lệnh (dễ nhất, khuyến nghị)

1. Đăng nhập https://github.com → bấm **New repository**.
2. Đặt tên repository là **`manlab-p21-test`** → chọn **Public** → **Create repository**.
3. Ở trang repo vừa tạo, bấm **uploading an existing file** (hoặc **Add file → Upload files**).
4. Kéo–thả **toàn bộ nội dung bên trong thư mục `manlab-p21-test`** (tức là `index.html`, `README.md`, `DEPLOY.md`) vào khung upload.
   - ⚠️ Kéo *các tệp bên trong*, không kéo cả thư mục cha, để `index.html` nằm ở gốc repo.
5. Bấm **Commit changes**.
6. Vào **Settings → Pages** (menu bên trái).
7. Mục **Build and deployment → Source**: chọn **Deploy from a branch**.
8. **Branch**: chọn `main` (hoặc `master`) và thư mục `/ (root)` → **Save**.
9. Chờ ~1 phút, tải lại trang Pages. Link test sẽ hiện ở đầu trang, dạng:

```
https://<tài-khoản-github>.github.io/manlab-p21-test/
```

10. Gửi link đó cho mọi người. Xong!

---

## Cách B — Dùng dòng lệnh (Git)

Mở terminal tại thư mục chứa `manlab-p21-test`, thay `<tài-khoản-github>` bằng tên của bạn:

```bash
cd manlab-p21-test

git init
git add .
git commit -m "manlab-p21-test - Module Cong bo/Thong bao nang luc (ban test)"
git branch -M main

# Tạo repo rỗng tên manlab-p21-test trên GitHub trước, rồi:
git remote add origin https://github.com/<tài-khoản-github>/manlab-p21-test.git
git push -u origin main
```

Sau đó bật Pages bằng giao diện (bước 6–9 ở Cách A), **hoặc** bằng GitHub CLI:

```bash
gh repo edit --enable-pages --pages-branch main
```

Link test:

```
https://<tài-khoản-github>.github.io/manlab-p21-test/
```

---

## Cập nhật phiên bản mới sau này

- **Cách A:** vào repo → **Add file → Upload files** → kéo `index.html` mới vào → **Commit changes** (ghi đè). Pages tự cập nhật sau ~1 phút.
- **Cách B:**
  ```bash
  git add index.html
  git commit -m "Cap nhat module P21"
  git push
  ```

---

## Lưu ý khi test

- Link Pages chạy tốt trên cả **máy tính và điện thoại**.
- Mỗi người test có **dữ liệu demo riêng** (lưu trên trình duyệt của họ); không ảnh hưởng lẫn nhau.
- Đăng nhập bằng tài khoản demo (xem `README.md`): `ldv / 123` (Lãnh đạo Viện), `ldp / 123` (Lãnh đạo phòng), `nth / 123` (Người thực hiện), `admin / 123`.
- Nút **Cập nhật từ ManLab** sẽ báo "không kết nối được" khi chạy trên Pages (do chưa mở API/CORS từ phía ManLab) và tự dùng dữ liệu nhúng — đây là hành vi đúng ở môi trường test công khai.

---

## Repo private nhưng vẫn muốn có link test?

GitHub Pages ở gói miễn phí yêu cầu repo **Public** để có link công khai. Nếu cần giữ mã nguồn riêng tư, có thể:
- Dùng **Netlify Drop** (https://app.netlify.com/drop): kéo–thả thư mục `manlab-p21-test` → nhận link ngay, không cần tài khoản GitHub công khai, hoặc
- Chia sẻ trực tiếp tệp `index.html` để người test mở cục bộ trên máy.
