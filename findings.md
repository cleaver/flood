# Findings & Decisions

## Requirements

- Subscribe to one feed URL.
- Refresh it through the existing HTTP/parser path.
- Persist feed metadata, cache validators, articles, and reader state locally.
- Display persisted articles in the timeline.
- Open and read an article, persisting read/starred state.

## Research Findings

- The project already has storage-agnostic feed/article contracts, normalized
  ingestion models, HTTP conditional fetching, and fixture-backed parsing.
- Current UI pages are static placeholders with no dependency composition.
- Drift is a reactive SQLite layer; `drift_flutter` 0.3.1 opens a persistent
  cross-platform database with a test-injectable constructor pattern.
- `flutter_widget_from_html_core` renders common HTML tags as Flutter widgets
  and accepts a base URL for resolving article links.
- `url_launcher` 6.3.2 supports opening publisher URLs on all Flutter targets.

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
