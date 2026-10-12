## Which file is for which platform?

| File | Platform |
|---|---|
| `ZCodeRTL-Setup-*.exe` | **Windows only** — the installer. Download, double-click, done. |
| `ZCodeRTL-v*.zip` | **All platforms** (portable) — Windows: extract and run `install.ps1` · Linux/macOS: extract and run `bash install.sh` |
| `checksums-sha256.txt` | Optional — verify your download: `sha256sum -c checksums-sha256.txt` |

**Quick install (no clone needed)**

- **Windows** — the `.exe` above, or in PowerShell: `irm https://raw.githubusercontent.com/ahmadkhanloo/ZCodeRTL/main/install.ps1 | iex`
- **Linux / macOS** — `curl -fsSL https://raw.githubusercontent.com/ahmadkhanloo/ZCodeRTL/main/install.sh | bash`

Requirements: [ZCode](https://zcode.z.ai/invite/CF3ZEFJR) and **Node.js ≥ 21**. The `.exe` is unsigned — Windows SmartScreen may warn (choose *More info → Run anyway*); you can verify the download against `checksums-sha256.txt`.

---

## کدام فایل مربوط به کدام سیستم‌عامل است؟

- ‏`ZCodeRTL-Setup-*.exe` → **فقط ویندوز** — نصب‌کننده؛ دانلود و دابل‌کلیک.
- ‏`ZCodeRTL-v*.zip` → **همهٔ سیستم‌عامل‌ها (پرتابل)** — ویندوز: بعد از بازکردن، `install.ps1` را اجرا کنید؛ لینوکس/مک: `bash install.sh`.
- ‏`checksums-sha256.txt` → بررسی سلامت فایل دانلودشده.

**‏نصب سریع بدون کلون** — ویندوز: فایل exe بالا یا `irm https://raw.githubusercontent.com/ahmadkhanloo/ZCodeRTL/main/install.ps1 | iex` · لینوکس/مک: `curl -fsSL https://raw.githubusercontent.com/ahmadkhanloo/ZCodeRTL/main/install.sh | bash`
