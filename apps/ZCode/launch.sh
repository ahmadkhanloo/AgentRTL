#!/usr/bin/env bash
# ZCode RTL launcher (Linux & macOS) — starts ZCode with the DevTools port and
# the hidden injector. Used by the "ZCode RTL" menu entry (Linux) and the
# ZCode RTL.app (macOS); in both cases nothing keeps a terminal open.

set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
# The DevTools port can be overridden with ZCODE_RTL_PORT (e.g. a second setup).
PORT="${ZCODE_RTL_PORT:-9222}"
export ZCODE_RTL_PORT="$PORT"

# GUI sessions on macOS start apps with a minimal PATH; make sure node resolves.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

EXE=""
if [ "$(uname -s)" = "Darwin" ]; then
  for p in "/Applications/ZCode.app/Contents/MacOS/ZCode" "$HOME/Applications/ZCode.app/Contents/MacOS/ZCode"; do
    if [ -x "$p" ]; then EXE="$p"; break; fi
  done
else
  if command -v zcode >/dev/null 2>&1; then EXE="$(command -v zcode)"; fi
  for p in /usr/bin/zcode /usr/local/bin/zcode /opt/ZCode/zcode /opt/zcode/zcode "$HOME/.local/bin/zcode"; do
    if [ -z "$EXE" ] && [ -x "$p" ]; then EXE="$p"; fi
  done
fi

if [ -z "$EXE" ]; then
  echo "[ZCode RTL] ZCode was not found in the standard locations." >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "[ZCode RTL] Node.js not found on PATH. Install Node 21+ from https://nodejs.org" >&2
  exit 1
fi
NODE_MAJOR="$(node --version | sed 's/^v//' | cut -d. -f1)"
if [ "$NODE_MAJOR" -lt 21 ]; then
  echo "[ZCode RTL] Node.js 21 or newer is required (found $(node --version))." >&2
  exit 1
fi

nohup "$EXE" --remote-debugging-port=$PORT >/dev/null 2>&1 &
nohup node "$DIR/injector.mjs" >/dev/null 2>&1 &
