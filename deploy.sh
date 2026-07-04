#!/usr/bin/env bash
#
# deploy.sh — Đóng gói manlab-p21-test và đẩy lên GitHub, bật GitHub Pages để lấy link test.
#
# Cách dùng (chạy tại thư mục chứa index.html):
#     chmod +x deploy.sh
#     ./deploy.sh                     # dùng tên repo mặc định "manlab-p21-test"
#     ./deploy.sh ten-repo-khac       # hoặc chỉ định tên repo
#     ./deploy.sh manlab-p21-test private     # tạo repo private (mặc định public để có Pages)
#
# Ưu tiên dùng GitHub CLI (gh) để tự tạo repo + bật Pages.
# Nếu không có gh, script sẽ hướng dẫn tạo repo thủ công rồi push bằng git.

set -euo pipefail

# ---- Tham số ----
REPO_NAME="${1:-manlab-p21-test}"
VISIBILITY="${2:-public}"          # public | private
BRANCH="main"

# ---- Màu ----
B="\033[1m"; G="\033[32m"; Y="\033[33m"; R="\033[31m"; N="\033[0m"
info(){ printf "${B}▶ %s${N}\n" "$1"; }
ok(){   printf "${G}✔ %s${N}\n" "$1"; }
warn(){ printf "${Y}! %s${N}\n" "$1"; }
err(){  printf "${R}✘ %s${N}\n" "$1"; }

# ---- Kiểm tra tiền đề ----
if ! command -v git >/dev/null 2>&1; then
  err "Chưa cài git. Cài git rồi chạy lại: https://git-scm.com/downloads"
  exit 1
fi

if [ ! -f "index.html" ]; then
  err "Không thấy index.html trong thư mục hiện tại."
  err "Hãy 'cd' vào thư mục manlab-p21-test (chứa index.html) rồi chạy lại script."
  exit 1
fi

# Đảm bảo có .nojekyll (GitHub Pages phục vụ tệp nguyên trạng)
[ -f ".nojekyll" ] || touch .nojekyll
# .gitignore tối thiểu
[ -f ".gitignore" ] || printf ".DS_Store\nThumbs.db\n" > .gitignore

# ---- Khởi tạo git repo cục bộ ----
if [ ! -d ".git" ]; then
  info "Khởi tạo git repository..."
  git init -q
fi

git add -A
if git diff --cached --quiet 2>/dev/null; then
  warn "Không có thay đổi mới để commit."
else
  git commit -q -m "manlab-p21-test — Module Cong bo/Thong bao nang luc (ban test)"
  ok "Đã commit."
fi
git branch -M "$BRANCH"

# ==================================================================
# TRƯỜNG HỢP 1: có GitHub CLI (gh) — tự động hoàn toàn
# ==================================================================
if command -v gh >/dev/null 2>&1; then
  info "Phát hiện GitHub CLI (gh)."

  # Đăng nhập nếu chưa
  if ! gh auth status >/dev/null 2>&1; then
    warn "Chưa đăng nhập GitHub CLI. Mở luồng đăng nhập..."
    gh auth login
  fi

  GH_USER="$(gh api user --jq .login)"
  ok "Đăng nhập với tài khoản: $GH_USER"

  # Tạo repo nếu chưa tồn tại
  if gh repo view "$GH_USER/$REPO_NAME" >/dev/null 2>&1; then
    warn "Repo $GH_USER/$REPO_NAME đã tồn tại — dùng lại."
    if ! git remote get-url origin >/dev/null 2>&1; then
      git remote add origin "https://github.com/$GH_USER/$REPO_NAME.git"
    fi
    info "Đẩy code lên..."
    git push -u origin "$BRANCH"
  else
    info "Tạo repo $VISIBILITY '$REPO_NAME' và đẩy code..."
    gh repo create "$REPO_NAME" "--$VISIBILITY" --source=. --remote=origin --push
  fi
  ok "Đã đẩy code lên GitHub."

  # Bật GitHub Pages (nhánh main, thư mục gốc)
  info "Bật GitHub Pages..."
  if gh api -X POST "repos/$GH_USER/$REPO_NAME/pages" \
        -f "source[branch]=$BRANCH" -f "source[path]=/" >/dev/null 2>&1; then
    ok "Đã bật GitHub Pages."
  else
    # Nếu đã bật trước đó thì cập nhật
    gh api -X PUT "repos/$GH_USER/$REPO_NAME/pages" \
        -f "source[branch]=$BRANCH" -f "source[path]=/" >/dev/null 2>&1 || true
    warn "Pages có thể đã được bật từ trước (bỏ qua)."
  fi

  echo
  ok "HOÀN TẤT!"
  printf "${B}Link test (chờ ~1 phút để build):${N}\n"
  printf "   ${G}https://%s.github.io/%s/${N}\n\n" "$GH_USER" "$REPO_NAME"
  printf "Repo: https://github.com/%s/%s\n" "$GH_USER" "$REPO_NAME"
  exit 0
fi

# ==================================================================
# TRƯỜNG HỢP 2: không có gh — dùng git thuần, cần tạo repo thủ công
# ==================================================================
warn "Không tìm thấy GitHub CLI (gh)."
echo
echo "Bạn có 2 lựa chọn:"
echo "  (A) Cài gh rồi chạy lại script (tự động hoàn toàn):"
echo "        macOS:   brew install gh"
echo "        Windows: winget install --id GitHub.cli"
echo "        Linux:   https://github.com/cli/cli#installation"
echo
echo "  (B) Tạo repo thủ công rồi push bằng git:"
printf "      1) Vào https://github.com/new → đặt tên: ${B}%s${N} → chọn ${B}Public${N} → Create.\n" "$REPO_NAME"
echo "      2) Chạy các lệnh sau (thay <tài-khoản-github> bằng tên của bạn):"
echo
echo "         git remote add origin https://github.com/<tài-khoản-github>/$REPO_NAME.git"
echo "         git push -u origin $BRANCH"
echo
echo "      3) Vào repo → Settings → Pages → Source: Deploy from a branch"
echo "         → Branch: $BRANCH / (root) → Save."
echo
echo "      Link test sẽ là:"
echo "         https://<tài-khoản-github>.github.io/$REPO_NAME/"
echo

# Nếu người dùng đã có remote origin, thử push luôn cho tiện
if git remote get-url origin >/dev/null 2>&1; then
  info "Đã thấy remote 'origin' — thử push..."
  if git push -u origin "$BRANCH"; then
    ok "Đã push. Giờ chỉ cần bật Pages theo bước (3) ở trên."
  else
    warn "Push chưa thành công — kiểm tra lại remote/đăng nhập."
  fi
fi
