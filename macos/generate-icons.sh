#!/bin/sh
# Xcode consumes PNG app-icon assets; the shared SVG remains the source.
set -eu

if ! command -v rsvg-convert >/dev/null 2>&1; then
  echo "Install librsvg (brew install librsvg on macOS) to regenerate icons." >&2
  exit 1
fi

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
icons=$project_dir/macos/Runner/Assets.xcassets/AppIcon.appiconset
for size in 16 32 64 128 256 512 1024; do
  rsvg-convert --width="$size" --height="$size" \
    "$project_dir/assets/icons/flood.svg" --output="$icons/app_icon_$size.png"
done
