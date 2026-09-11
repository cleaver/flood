# Findings & Decisions

## Requirements

- Subscribe to one feed URL.
- Refresh it through the existing HTTP/parser path.
- Persist feed metadata, cache validators, articles, and reader state locally.
- Display persisted articles in the timeline.
- Open and read an article, persisting read/starred state.
- Subscribe to and manage multiple feeds.
- Avoid repeated timeline entries when feeds expose the same story.
- Let readers filter and star articles, and recover from failed operations.
- Start from persisted content when the device is offline.
- Handle timeout, redirect, malformed XML, missing dates, duplicate GUIDs, and
  enormous feeds safely.

## Research Findings

- The project already has storage-agnostic feed/article contracts, normalized
  ingestion models, HTTP conditional fetching, and fixture-backed parsing.
- Current UI pages are static placeholders with no dependency composition.
- Drift is a reactive SQLite layer; `drift_flutter` 0.3.1 opens a persistent
  cross-platform database with a test-injectable constructor pattern.
- `flutter_widget_from_html_core` renders common HTML tags as Flutter widgets
  and accepts a base URL for resolving article links.
- `url_launcher` 6.3.2 supports opening publisher URLs on all Flutter targets.
- The project now has a clean Git baseline at `a32fbaa initial commit`.
- `ArticleRows` are intentionally unique only by `(feedId, sourceKey)`, so the
  existing implementation preserves every feed copy but shows duplicates in a
  unified timeline.
- The existing `ArticleQuery` already filters by one feed and by all, unread,
  or starred state; the timeline currently exposes only the latter three.
- Reader starring is already persisted. Feed failures are stored as
  `refreshError`, but the UI currently only displays text/snackbars and offers
  no explicit retry, URL correction, or removal path.
- Feed unsubscribe currently depends on foreign-key behavior and must delete
  dependent reader state and articles explicitly before deleting the feed.
- RSS/Atom parsing resolves article URLs against each feed's site URL, making a
  normalized article URL the safest available cross-feed duplicate signal.
- The subscription screen already renders an arbitrary feed list, so the
  remaining UI work is recovery actions per feed rather than a new list model.
- The timeline needs a feed picker alongside its existing All/Unread/Saved
  control; tile-level star controls make saved-state management fast.
- Fetching currently applies its timeout only while opening the HTTP response;
  a slow response body can outlive that deadline. The deadline must cover the
  complete headers-and-body operation.
- The fetcher accepts the final `response.request.url` as the source URI, so a
  real redirect test can verify relative links resolve against the endpoint
  that served the feed.
- The parser already accepts missing dates as `null`; `Article.sortDate` falls
  back to `fetchedAt`.
- Duplicate GUIDs currently upsert to one database row, but refresh new-item
  counts should first collapse duplicated source keys.
- The existing response-size check runs after buffering a chunk. It should
  reject a chunk that would exceed the limit before retaining it.
- A successful `FeedLoaded` refresh is the only safe point to compare the
  upstream set with local rows; timeout, HTTP, and parse failures must leave
  removal flags unchanged.
- The current article state table is separate from publisher fields, so a
  removed flag can be added without changing read/starred/scroll semantics.
- Timeline rows already have a leading status icon and the reader has an AppBar
  action area; these are the smallest accessible places to explain removal.
- A boolean `isRemoved` on `ArticleRows` fits the ownership boundary: it can be
  updated during refresh while `ArticleStateRows` remains untouched.
- The migration must default existing rows to `false`; only a successful
  `FeedLoaded` response can mark absent rows as removed, while `304` and failed
  requests leave the previous marker unchanged.
- The Linux development database is `/home/cleaver/Documents/flood.sqlite` because
  `drift_flutter` stores `flood.sqlite` in the application documents directory.
- The live `https://cleaver.ca/rss.xml` response currently contains 18 items,
  while the local database contains 22 rows for that feed. Four older rows are
  absent from the live XML but still have `is_removed = 0`.
- The feed's stored validator (`W/"da1b4118eb2fa55b8e9297c91c60fbfa"`) receives
  `304 Not Modified`, while an unconditional request returns the 18-item body.
  This stale-validator response explains why the repository never entered its
  successful full-snapshot reconciliation branch.
- Manual refreshes now bypass stored validators (`force: true`) so the UI can
  detect removals despite a stale upstream ETag. Conditional refresh remains the
  default repository behavior for non-interactive callers.
- The current cleaver.ca RSS feed's descriptions are Markdown-like plain text:
  headings (`##`), emphasis (`*...*`/`_..._`), links (`[label](url)`), blockquotes,
  and footnote syntax appear without meaningful HTML tags.
- The current Simon Willison Atom feed's summaries contain escaped, structured
  HTML (`<p>`, `<blockquote>`, `<ul>`, `<img>`, `<video>`, and code blocks), so
  they must stay on the existing HTML rendering path.
- Markdown conversion should happen at reader presentation time, not ingestion,
  so the original feed payload remains available and a future renderer can make
  a different choice without refetching.
- A conservative detector should require Markdown structure (for example a
  heading, link, list, quote, or emphasis marker) and reject content containing
  meaningful HTML tags. Plain prose should remain plain text rather than being
  needlessly transformed.
- The official Dart `markdown` package (7.3.1) converts Markdown to HTML and
  supports GitHub-flavored fenced code, tables, strikethrough, and footnotes.
  Its HTML output can feed the existing `HtmlWidget`, preserving the current
  link callback and base-URL behavior.
- The formatter treats block-level HTML as authoritative. Inline HTML may be
  retained inside a Markdown conversion, which handles cleaver.ca's opening
  image-credit link without reinterpreting Simon Willison's rich summaries.

## Technical Decisions

| Decision | Rationale |
|---|---|
| Cache-first repository streams | The UI should render SQLite data immediately and update after refresh |
| Use Drift with `drift_flutter` | Reactive queries match repository streams, while in-memory executors make persistence tests deterministic |
| Use the core HTML renderer | Provides readable feed-supplied markup without webviews or full-page scraping |
| Use `url_launcher` for original links | Keeps cross-platform publisher-link handling outside the renderer |

## Issues Encountered

| Issue | Resolution |
|---|---|

## Resources

- `docs/schema-v1.sql`
- `docs/data-model.md`
- `lib/core/feed_ingestion/feed_loader.dart`
- https://pub.dev/packages/drift_flutter
- https://pub.dev/packages/drift
- https://pub.dev/packages/flutter_widget_from_html_core
- https://pub.dev/packages/url_launcher

## Visual/Browser Findings

- Drift Flutter supports native and web targets, but a web release will require
  the documented SQLite WASM assets.

## Window-size Persistence Findings

- The running Flood app is a Flutter desktop application. The current Linux
  runner calls `gtk_window_set_default_size(window, 1280, 720)` and the Windows
  runner creates a `1280x720` window at startup.
- `lib/main.dart` currently calls `runApp` directly. There is no desktop window
  lifecycle initialization or persisted UI-preferences store.
- The existing Drift database is responsible for feed/article content and
  reader state. Window dimensions are application preferences, so they should
  not require a Drift schema migration.
- The requested behavior is interpreted as restoring the app window's width
  and height. It does not change the operating system's monitor resolution.
- The feature should be desktop-only. Mobile and web builds should compile and
  behave as no-ops because they do not expose the same resizable native window
  lifecycle.
- A small `window_manager` integration can read/apply dimensions and observe
  resize/close events. `shared_preferences` is sufficient for two persisted
  values and keeps the content database boundary clean.
- The restored dimensions need validation: missing or corrupt values use the
  existing `1280x720` fallback, values below a minimum usable size are raised
  to that minimum, and non-finite/out-of-range values must not be applied.
- Resize writes should be debounced. The latest valid restored size should be
  flushed on close so a rapid resize followed by quit does not lose state.
- The implementation should not overwrite the user's restored size with
  maximized/fullscreen bounds. Position persistence is outside this feature;
  if added later, it must validate monitor/work-area availability separately.

## Window-size Technical Decisions

| Decision | Rationale |
|---|---|
| Store only width and height in `shared_preferences` | This is lightweight UI state and does not belong in the feed/content schema |
| Use `window_manager` behind a desktop-gated boundary | Centralizes Linux, Windows, and macOS window lifecycle behavior without changing feature pages |
| Keep `1280x720` as the fallback and use a minimum such as `640x480` | Existing behavior remains safe on first launch or after corrupt preferences |
| Apply saved size before showing the first frame | Prevents an obvious default-size flash on relaunch |
| Debounce resize writes and flush on close | Avoids excessive preference writes while preserving the final size |
| Do not persist position, maximize, or fullscreen state in the first slice | The request only requires dimensions and these states have additional monitor/display edge cases |

## Window-size Verification Findings

- `window_manager` 0.5.2 and `shared_preferences` 2.5.5 resolve on the
  project's Flutter/Dart versions.
- Flutter regenerated Linux, Windows, and macOS plugin registrants. The Linux
  registrant includes `window_manager` and `screen_retriever`; macOS and
  Windows registrants include the corresponding native plugins.
- `flutter analyze` is clean, the focused window suite passes 11 tests, and
  the complete Flutter suite passes 50 tests.
- `flutter build linux --debug` succeeds. A direct Linux runtime startup also
  succeeds without missing-plugin errors; the new window is titled `Flood` and
  the Linux preferences file contains the expected width and height keys.
- `flutter build web` succeeds, confirming the conditional stub excludes the
  desktop window-manager implementation from web compilation.
- The runtime preference file is stored under
  `/home/cleaver/.local/share/ca.cleaver.flood/shared_preferences.json` in this
  development environment. This is evidence of the plugin path only; the app
  code does not depend on that absolute location.
- The Linux `window_manager` plugin emits resize events from GTK's resize and
  configure hooks, so the controller's listener receives native Linux resizes
  as well as the macOS/Windows completion event when available.

## Design review — 2026-09-11

- Reviewed all presentation source and the product brief; no running UI or screenshots inspected.
- Material 3 generated colour schemes, unconditional bottom navigation, full-width lists, and unconstrained reader text account for much of the generic presentation.
- Today is not date-limited. Article dates and summaries exist but are not displayed in rows.
- Settings is static; In app contradicts externalApplication link launching.
- Apple materials search result describes Liquid Glass for controls/navigation: https://developer.apple.com/design/human-interface-guidelines/materials . Direct HIG page reads require JavaScript, so no further claims are based on those unavailable bodies.

- Recommended quiet editorial direction: neutral surfaces, crisp blue accent, custom article rows, constrained reading column, and adaptive desktop sidebar/list/reader layout. Detailed proposals are in docs/design-review.md.

- User confirmed: retain app dark mode and allow white-background article reading independently. Review now specifies separate app/reader preferences and a complete reader palette.
