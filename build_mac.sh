#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

PYTHON_BIN="${PYTHON:-python3}"

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
  --add-data "UI/Image/favicon.ico:UI/Image" \
  --collect-all PySide6 \
  --collect-all shiboken6

echo "macOS app bundle created at dist/RainClassroomAssistant.app"
