# Show available commands.
default:
    @just --list

# Build and install a release for the current desktop platform.
install:
    #!/bin/sh
    set -eu
    case "$(uname -s)" in
        Linux) just install-linux ;;
        Darwin) just install-macos ;;
        *) echo "Desktop installation supports Linux and macOS." >&2; exit 1 ;;
    esac

# Build the Linux release bundle.
build-linux:
    @test "$(uname -s)" = Linux || { echo "Build Linux releases on Linux." >&2; exit 1; }
    flutter build linux --release

# Build Linux and install the user desktop entry and icon.
install-linux: build-linux
    ./linux/install-desktop.sh

# Build the macOS release app.
build-macos:
    @test "$(uname -s)" = Darwin || { echo "Build macOS releases on macOS." >&2; exit 1; }
    flutter build macos --release

# Build macOS and install the app in ~/Applications.
install-macos: build-macos
    ./macos/install-desktop.sh

# Regenerate committed macOS icons from the SVG (requires rsvg-convert).
icons-macos:
    ./macos/generate-icons.sh

# Check desktop build/install workflows using fixture bundles.
test-tools:
    python3 -m unittest discover -s test/tool -p '*_test.py'
