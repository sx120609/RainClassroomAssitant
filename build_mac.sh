#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

PYTHON_BIN="${PYTHON:-python3}"

# PyQt5 wheels are only published for Python 3.12 and below.
PY_VERSION="$("$PYTHON_BIN" - <<'PY'
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}")
PY
)"
PY_MAJOR="${PY_VERSION%%.*}"
PY_MINOR="${PY_VERSION#*.}"

if [ "$PY_MAJOR" -gt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -ge 13 ]; }; then
  echo "Detected Python ${PY_VERSION}. Please use Python 3.12 or earlier so PyQt5 wheels are available."
  exit 1
fi

if [ ! -d ".venv" ]; then
  "$PYTHON_BIN" -m venv .venv
fi

source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt pyinstaller

pyinstaller RainClassroomAssistant.py \
  --noconfirm \
  --windowed \
  --name RainClassroomAssistant \
  --icon UI/Image/favicon.ico \
  --add-data "UI/Image/NoRainClassroom.jpg:UI/Image" \
  --add-data "UI/Image/favicon.ico:UI/Image"

echo "macOS app bundle created at dist/RainClassroomAssistant.app"
