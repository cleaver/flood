#!/bin/sh
# Install the release app for the current user, without sudo.
set -eu

if [ "$(uname -s)" != Darwin ]; then
  echo "Install macOS releases on macOS." >&2
  exit 1
fi

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
bundle=${1:-$project_dir/build/macos/Build/Products/Release/flood.app}
applications_dir=${FLOOD_APPLICATIONS_DIR:-$HOME/Applications}
destination=$applications_dir/Flood.app

if [ ! -f "$bundle/Contents/Info.plist" ] || [ ! -x "$bundle/Contents/MacOS/flood" ]; then
  echo "Build Flood first with: flutter build macos --release" >&2
  exit 1
fi
if [ -L "$destination" ]; then
  echo "Cannot replace a symbolic link at $destination." >&2
  exit 1
fi

mkdir -p "$applications_dir"
# Preserve executable permissions and framework symlinks; remove stale files
# from earlier builds only within Flood.app.
rsync -a --delete -- "$bundle/" "$destination/"
touch "$destination"
echo "Installed $destination. Quit Flood and reopen the installed app to update its icon."
