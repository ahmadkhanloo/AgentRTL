# ZCode RTL

<p align="center">
  <img src="docs/hero.png" alt="Before: a Persian answer rendered LTR and scrambled. After: correct RTL — while code blocks stay LTR." width="100%">
</p>

<!--
GitHub About / description (copy into the repo "About" field):
Make ZCode chat render Persian, Arabic, Hebrew, Urdu — any RTL language — correctly. Per-paragraph auto-direction, code stays LTR. No app patching, survives updates, one-command install.
-->

Make [ZCode](https://z.ai) — Z.ai's AI coding IDE — render Persian (and any RTL language) correctly in its chat.

AI tools assume English. ZCode renders every message left-to-right, so Persian answers look scrambled: punctuation lands on the wrong side and English words jump around mid-sentence. **ZCode RTL fixes that with one CSS rule, injected at runtime — the app itself is never modified.**

نسخهٔ فارسی: [README.fa.md](README.fa.md)

## 🌍 Supported languages

Any right-to-left script — direction is detected per paragraph, so English text and code blocks are never touched:

**Persian (Farsi)** · **Arabic** · **Hebrew** · **Urdu** · **Dari** · **Kurdish** · **Pashto** · **Uyghur** · **Yiddish** · **Sindhi** …

## ✨ What you get

- **Auto RTL per paragraph** — each block follows its first strong character: Persian → RTL, English → LTR, even inside a single message
- **Mixed text handled** — Persian paragraphs containing English words, numbers and file paths stay readable
- **Code blocks stay LTR** — `pre`/`code` are deliberately excluded
- **Composer too** — the input box auto-switches direction while you type
- **Self-healing** — re-injects into reloaded pages and new windows automatically
- **Invisible** — runs hidden in the background: no console window, no taskbar entry
- **Lightweight & single-instance** — one local HTTP request every 2 s, a few MB of RAM; duplicates exit automatically

## 🆚 Why not just patch the app?

| Approach | The problem |
|---|---|
| Patching `app.asar` | Breaks on **every app update**, needs **admin rights**, can corrupt the install |
| Injecting CSS by hand in DevTools | Gone after **every reload or restart** |
| Copy-pasting answers elsewhere to read them | Leaves your workflow every time |
| Waiting for official RTL support | 🙂 |

ZCode RTL **touches nothing inside the app**: it uses the app's own Chromium DevTools port to inject one stylesheet at runtime. App updates don't affect it, no admin rights are needed, and uninstalling is one command.

## 🚀 Install

### Quick install — one step, done

**Windows** — either the **installer**: download `ZCodeRTL-Setup-*.exe` from [Releases](../../releases) and double-click it (it installs the files and creates the **ZCode RTL** shortcut for you) — or the **one-liner** in PowerShell:

```powershell
irm https://raw.githubusercontent.com/ahmadkhanloo/ZCodeRTL/main/install.ps1 | iex
```

**Linux / macOS** — one command in a terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/ahmadkhanloo/ZCodeRTL/main/install.sh | bash
```

Either way you end up with a **ZCode RTL** launcher: the desktop shortcut on Windows, an applications-menu entry (plus a desktop icon) on Linux, a `ZCode RTL.app` in `~/Applications` on macOS. Start ZCode from it and RTL just works.

> The Windows installer is unsigned, so SmartScreen may warn about it (choose *More info → Run anyway*), and some antivirus tools may flag it as a false positive. If that happens, use the one-liner instead — or verify the file against the `checksums-sha256.txt` attached to the release.

### Professional install — review, customize, portable

Clone and inspect the source first, then install from the checkout (identical from an extracted [Releases](../../releases) zip):

```bash
git clone https://github.com/ahmadkhanloo/ZCodeRTL.git
cd ZCodeRTL
# worth a look: injector.mjs, launch.vbs / launch.sh, install.ps1 / install.sh
powershell -ExecutionPolicy Bypass -File install.ps1   # Windows
bash install.sh                                        # Linux / macOS
```

What professionals get:

- **Custom DevTools port** — set `ZCODE_RTL_PORT` (default `9222`) in the environment before using the launcher; app and injector both follow it.
- **Run from source** — the launcher works from any folder, so a git checkout can be the install location itself.
- **Clean uninstall** — `powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall` or `bash install.sh --uninstall` (or *Settings → Apps* for the Setup.exe).

Requirements (all platforms): [ZCode](https://z.ai) installed and **Node.js ≥ 21** on PATH (its built-in WebSocket is used).

## ▶️ Use

Fully quit ZCode (also from the system tray), then start it with the new **ZCode RTL** launcher — the desktop shortcut on Windows, the applications-menu entry (and desktop icon) on Linux, `ZCode RTL.app` on macOS. That's it — Persian messages now render RTL.

> The debug port only exists when ZCode is started through the shortcut, so use the shortcut instead of the normal icon.

## 🧰 Troubleshooting

- **Still LTR?** ZCode was started from the normal icon. Close it completely and start via **ZCode RTL**.
- **Worked before, stopped after an update?** The updater relaunched ZCode without the port. Same fix: close fully → start via the shortcut.
- **Is it running?** Windows: Task Manager → look for `node.exe` (the hidden injector). Linux/macOS: `pgrep -f injector.mjs`.
- **Uninstall:** Windows `powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall` (or *Settings → Apps* if you used the Setup.exe); Linux/macOS `bash install.sh --uninstall`.

## 🔒 Security note

While ZCode runs via the shortcut it exposes a DevTools port (`127.0.0.1:9222`) that **any local process** can reach. It is localhost-only, but keep it in mind on shared machines.

## ⚙️ How it works

A launcher starts ZCode with `--remote-debugging-port=9222` and launches a ~100-line Node script (`injector.mjs`) that connects to the Chromium DevTools Protocol and injects one CSS rule into every window. The launcher is `launch.vbs` on Windows (run through `wscript.exe`, so no console window ever appears) and `launch.sh` on Linux/macOS. New windows are injected in real time via the DevTools `targetCreated` event — the polling loop is only a safety net:

```css
:is(p, li, h1, h2, h3, blockquote, td, textarea, ...) {
  unicode-bidi: plaintext; /* direction = first strong character */
  text-align: start;
}
```

`plaintext` lets every paragraph pick its own direction, so one message can contain a Persian paragraph and an English one — each rendered correctly. Code blocks are excluded and stay LTR.

## License

[MIT](LICENSE) — the bundled [Vazirmatn](https://github.com/rastikerdar/vazirmatn) font (used in the banner) is under the [SIL Open Font License 1.1](docs/fonts/OFL.txt).
