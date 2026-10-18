# AgentRTL

RTL fixes for AI coding apps. Choose the apps you use in one Windows installer; each app keeps its own launcher and CSS rules.

نسخهٔ فارسی: [README.fa.md](README.fa.md)

| App | Windows | Linux / macOS |
|---|---:|---:|
| [ZCode](apps/ZCode/README.md) | Yes | Yes |
| [Qoder](apps/Qoder/README.md) | Yes | — |
| [DeepSeek Harness](apps/DeepSeekHarness/README.md) | Yes | — |

## Install

Download `AgentRTL-Setup-*.exe` from [Releases](https://github.com/ahmadkhanloo/AgentRTL/releases), choose the apps to add, then finish setup. The installer checks that each selected app and Node.js 21 or newer are installed. It does not close an already-running app; fully quit it and open it from the new RTL shortcut.

For a source checkout, run PowerShell from the repository folder:

```powershell
.\install.ps1 -Apps zcode,qoder,deepseek
```

The source installer creates desktop shortcuts that point into the checkout. `-WhatIf` previews them; `-Uninstall` stops injectors from this checkout and removes only shortcuts that point back to it. The source files remain in place. On Linux or macOS, the existing ZCode installer remains available:

```bash
bash install.sh
```

## Ports and security

The launchers use DevTools ports 9222 (ZCode), 9225 (Qoder), and 9228 (DeepSeek Harness). These are bound to localhost and allow local processes to inspect and control the app's windows while the app is running.

## License

The project code is MIT licensed. Bundled Vazirmatn font files are under the SIL Open Font License 1.1; see the license files in each app folder.
