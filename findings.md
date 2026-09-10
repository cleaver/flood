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
