# Run Flask + Cloudflare Tunnel together.
# 2 цонх нээгдэнэ: нэг нь Flask, нөгөө нь cloudflared (public URL-ыг харуулна).
# Зогсоохын тулд хоёр цонхыг хаах эсвэл Ctrl+C дарна.

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$python = Join-Path $root ".venv\Scripts\python.exe"

if (-not (Test-Path $python)) {
    Write-Host "[!] .venv олдсонгүй. Эхлээд venv-ийг үүсгэнэ үү:" -ForegroundColor Yellow
    Write-Host "    python -m venv .venv; .\.venv\Scripts\pip install -r requirements.txt"
    exit 1
}

$cloudflared = (Get-Command cloudflared -ErrorAction SilentlyContinue).Source
if (-not $cloudflared) { $cloudflared = "C:\Program Files (x86)\cloudflared\cloudflared.exe" }
if (-not (Test-Path $cloudflared)) {
    Write-Host "[!] cloudflared олдсонгүй. Суулгана уу:" -ForegroundColor Yellow
    Write-Host "    winget install Cloudflare.cloudflared"
    exit 1
}

Write-Host "==> Flask сэрвэр асааж байна (http://127.0.0.1:5000) ..." -ForegroundColor Cyan
Start-Process -FilePath $python `
    -ArgumentList "$root\app.py" `
    -WorkingDirectory $root `
    -WindowStyle Normal

Start-Sleep -Seconds 2

Write-Host "==> Cloudflare Tunnel асааж байна. Public URL дараагийн цонхонд гарна." -ForegroundColor Cyan
Write-Host "    URL нь 'https://....trycloudflare.com' хэлбэртэй."
Write-Host ""
Start-Process -FilePath $cloudflared `
    -ArgumentList "tunnel","--url","http://localhost:5000" `
    -WindowStyle Normal

Write-Host "Бэлэн. URL-ыг cloudflared цонхноос copy хийж бусдад илгээ." -ForegroundColor Green
Write-Host "Зогсоохдоо хоёр цонхыг хаа эсвэл Ctrl+C дар."
