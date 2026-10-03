#!/bin/sh
# Register a built bundle with the current user's desktop (no sudo required).
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
bundle=$(realpath "${1:-$project_dir/build/linux/x64/release/bundle}")
app_id=ca.cleaver.flood
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

if [ ! -x "$bundle/flood" ]; then
  echo "Build Flood first with: flutter build linux" >&2
  exit 1
fi
if ! command -v desktop-file-install >/dev/null 2>&1; then
  echo "Install desktop-file-utils to register the desktop launcher." >&2
  exit 1
fi

icon_dir=$data_dir/icons/hicolor/scalable/apps
mkdir -p "$icon_dir" "$data_dir/applications"
cp "$bundle/share/icons/hicolor/scalable/apps/$app_id.svg" "$icon_dir/$app_id.svg"

# Escape the Exec argument; desktop-file-install adds the key-value escaping.
exec_path=$(printf '%s' "$bundle/flood" | sed 's/\\/\\\\/g; s/"/\\"/g; s/`/\\`/g; s/\$/\\$/g; s/%/%%/g')
desktop-file-install --dir="$data_dir/applications" \
  --set-key=Exec --set-value="\"$exec_path\"" \
  "$bundle/share/applications/$app_id.desktop"

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache --force --ignore-theme-index "$data_dir/icons/hicolor"
fi
echo "Registered Flood. Restart the app to update its desktop and Alt-Tab icon."
