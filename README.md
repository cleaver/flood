# Flood

A calm, local-first RSS reader built with Flutter.

## Product

The MVP brief is in [docs/product-brief.md](docs/product-brief.md).
The persistence contract is in [docs/data-model.md](docs/data-model.md), with
the initial SQLite schema in [docs/schema-v1.sql](docs/schema-v1.sql).

## Structure

Feature code lives under `lib/features/`. The app shell owns Timeline,
Subscriptions, and Settings; Article is a route entered from Timeline once feed
items exist.

## Getting Started

Flood currently supports a resilient multi-feed reading slice:

1. Add and manage multiple HTTP or HTTPS RSS/Atom feeds from Subscriptions.
2. Fetch, parse, and atomically persist the feed and its articles.
3. Refresh one feed or all feeds; manual refreshes bypass cached validators so
   publisher-side removals are detected, then retry failures.
4. Correct a feed URL safely: Flood verifies and fetches the replacement before
   updating the saved subscription.
5. Filter the reactive timeline by feed, All, Unread, or Saved.
6. Deduplicate entries with the same canonical article URL across feeds while
   keeping each feed's original record.
7. Render Markdown-like feed content with the same HTML reader, while leaving
   rich HTML untouched; open the original URL and save an article from a
   timeline row or the reader.
8. Read articles in a constrained editorial column with selectable serif or
   sans-serif prose; Flood remembers the font pairing and reading position.

Install dependencies and run the app with:

```sh
flutter pub get
flutter run
```

When the Drift schema changes, regenerate its companion code with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Verify the project with:

```sh
flutter analyze
flutter test
```

The Android release manifest includes network access for feed refreshes.

## Desktop builds and installation

The app icon source is [assets/icons/flood.svg](assets/icons/flood.svg). Linux
embeds the SVG in the native runner and includes a desktop launcher in the build
bundle. macOS uses PNGs generated from the same SVG in its Xcode asset catalog.

With Flutter and [Just](https://just.systems/) installed, run this on Linux or
macOS to build a release and install it for your user account:

```sh
just install
```

Explicit recipes are `just install-linux` and `just install-macos`. Each builds
on its own platform. `just build-linux` and `just build-macos` build without
installing. Run `just` to list the recipes.

On **Linux**, install `desktop-file-utils` first. Installation copies the SVG
into your user icon theme, installs a `.desktop` entry, and refreshes the icon
cache when that tool is available. This covers the launcher and Alt-Tab on
Wayland. The launcher points at `build/linux/x64/release/bundle/flood`; keep the
whole bundle together and rerun installation if you move the project. You can
also register another bundle with `./linux/install-desktop.sh /path/to/bundle`.

On **macOS**, the Flutter macOS toolchain must be configured, including Xcode.
Installation copies the complete release app to `~/Applications/Flood.app`,
including its icon and frameworks. Reinstalling updates that copy and removes
obsolete files within it. To use a different Applications directory, set
`FLOOD_APPLICATIONS_DIR` when running `just install-macos`.

Quit Flood and reopen it from the installed launcher or app after installation
so its desktop icon updates. These recipes install local release builds.

After changing the SVG, run `just icons-macos` and commit the updated PNG assets.
This regeneration command needs `rsvg-convert` from librsvg (`brew install
librsvg` on macOS); normal builds use the committed PNGs. Windows, Android,
iOS, and web retain their existing icons.

The desktop installer checks run with `just test-tools` (Python 3, Just,
`desktop-file-utils`, and rsync). They use temporary fixture bundles and do not
change your installed app.

## Desktop window behavior

On Linux, macOS, and Windows, Flood remembers the last normal window width and
height and restores them on the next launch. The first-launch fallback is
1280×720, with a 640×480 minimum. Maximized and fullscreen bounds are not saved;
mobile and web builds do not apply desktop window persistence.

On desktop, Escape returns from the article reader to the timeline. Linux and
Windows also accept a rightward trackpad pan; macOS uses the native swipe event
when the OS delivers its configured page-navigation gesture. Windows also
accepts the OS browser-back command. The reader ignores these inputs when its
route is covered by another page.

## Resilience behavior

- Flood opens its local database before any refresh, so previously downloaded
  feeds and articles remain readable while offline.
- A feed download has a 15-second end-to-end deadline by default; it covers
  both response headers and body bytes.
- HTTP redirects are followed by the platform client. Relative links are then
  resolved against the final feed URL.
- Invalid XML, timeouts, HTTP errors, and oversized responses fail before
  publisher data is written. A failed refresh keeps prior articles available.
- Responses are limited to 5 MiB by default, including protection against a
  single oversized response chunk.
- Missing dates are valid and sort by fetch time. Repeated GUIDs in one feed
  resolve to the final occurrence.
- Routine repository refreshes send HTTP cache validators. Manual refreshes
  intentionally skip them so a stale upstream ETag cannot hide removals.
- Entries absent from a successful refresh are retained and labeled “Removed
  from feed”; a failed or `304 Not Modified` refresh never applies that label.
- Article content is formatted at display time when it has recognizable
  Markdown structure and no block-level HTML. Rich HTML feeds stay on the
  original HTML path, and simple inline HTML in Markdown is preserved by the
  converter.

## Flutter Resources

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
