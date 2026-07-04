<#
  deploy.ps1 — Đóng gói manlab-p21-test và đẩy lên GitHub, bật GitHub Pages (Windows PowerShell).

  Cách dùng (mở PowerShell tại thư mục chứa index.html):
      # Nếu bị chặn chạy script, mở quyền cho phiên hiện tại:
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

      .\deploy.ps1                      # repo mặc định "manlab-p21-test", public
      .\deploy.ps1 -RepoName ten-khac   # đổi tên repo
      .\deploy.ps1 -Visibility private  # tạo repo private

  Ưu tiên dùng GitHub CLI (gh). Nếu không có gh, hiển thị hướng dẫn push thủ công.
#>

param(
  [string]$RepoName = "manlab-p21-test",
  [ValidateSet("public","private")][string]$Visibility = "public",
  [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
function Info($m){ Write-Host "> $m" -ForegroundColor Cyan }
function Ok($m){ Write-Host "OK $m" -ForegroundColor Green }
function Warn($m){ Write-Host "! $m" -ForegroundColor Yellow }
function Fail($m){ Write-Host "x $m" -ForegroundColor Red }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Fail "Chua cai git. Cai tai: https://git-scm.com/downloads"; exit 1
}
if (-not (Test-Path "index.html")) {
  Fail "Khong thay index.html trong thu muc hien tai."
  Fail "Hay 'cd' vao thu muc manlab-p21-test (chua index.html) roi chay lai."; exit 1
}

if (-not (Test-Path ".nojekyll")) { New-Item -ItemType File -Name ".nojekyll" | Out-Null }
if (-not (Test-Path ".gitignore")) { ".DS_Store`r`nThumbs.db" | Out-File -Encoding ascii ".gitignore" }

if (-not (Test-Path ".git")) { Info "Khoi tao git repository..."; git init -q }
git add -A
git commit -q -m "manlab-p21-test - Module Cong bo/Thong bao nang luc (ban test)" 2>$null
git branch -M $Branch

if (Get-Command gh -ErrorAction SilentlyContinue) {
  Info "Phat hien GitHub CLI (gh)."
  gh auth status *> $null
  if ($LASTEXITCODE -ne 0) { Warn "Chua dang nhap gh. Mo luong dang nhap..."; gh auth login }

  $GhUser = (gh api user --jq .login)
  Ok "Dang nhap: $GhUser"

  gh repo view "$GhUser/$RepoName" *> $null
  if ($LASTEXITCODE -eq 0) {
    Warn "Repo $GhUser/$RepoName da ton tai - dung lai."
    git remote get-url origin *> $null
    if ($LASTEXITCODE -ne 0) { git remote add origin "https://github.com/$GhUser/$RepoName.git" }
    git push -u origin $Branch
  } else {
    Info "Tao repo $Visibility '$RepoName' va day code..."
    gh repo create $RepoName "--$Visibility" --source=. --remote=origin --push
  }
  Ok "Da day code len GitHub."

  Info "Bat GitHub Pages..."
  gh api -X POST "repos/$GhUser/$RepoName/pages" -f "source[branch]=$Branch" -f "source[path]=/" *> $null
  if ($LASTEXITCODE -ne 0) {
    gh api -X PUT "repos/$GhUser/$RepoName/pages" -f "source[branch]=$Branch" -f "source[path]=/" *> $null
  }
  Ok "Da bat GitHub Pages."

  Write-Host ""
  Ok "HOAN TAT!"
  Write-Host "Link test (cho ~1 phut de build):" -ForegroundColor White
  Write-Host "   https://$GhUser.github.io/$RepoName/" -ForegroundColor Green
  Write-Host "Repo: https://github.com/$GhUser/$RepoName"
  exit 0
}

Warn "Khong tim thay GitHub CLI (gh)."
Write-Host ""
Write-Host "Lua chon:"
Write-Host "  (A) Cai gh roi chay lai:  winget install --id GitHub.cli"
Write-Host "  (B) Tao repo thu cong roi push:"
Write-Host "      1) https://github.com/new -> ten: $RepoName -> Public -> Create"
Write-Host "      2) git remote add origin https://github.com/<tai-khoan>/$RepoName.git"
Write-Host "         git push -u origin $Branch"
Write-Host "      3) Settings -> Pages -> Deploy from a branch -> $Branch / (root) -> Save"
Write-Host "      Link: https://<tai-khoan>.github.io/$RepoName/"
