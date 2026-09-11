# Progress Log

## Session: 2026-09-09

### Session: 2026-09-10

### Phase 20: Discover Markdown and HTML content shapes

- **Status:** complete
- Actions taken:
  - Started a rendering investigation for Markdown-heavy cleaver.ca content
    and rich HTML from simonwillison.net.
  - Confirmed the existing reader sends stored content directly to
    `flutter_widget_from_html_core`.
  - Verified live cleaver.ca descriptions use Markdown-like headings,
    emphasis, links, and blockquotes; Simon Willison summaries use escaped
    rich HTML with paragraphs, lists, code, images, and video.

### Phase 21: Define a conservative Markdown rendering policy

- **Status:** complete
- Actions taken:
  - Chose the official Dart `markdown` package as a Markdown-to-HTML adapter.
  - Defined detection that requires recognizable Markdown signals and skips
    content containing block-level HTML.
  - Kept formatting at presentation time so stored feed payloads remain raw.

### Phase 22: Implement and test Markdown-aware article rendering

- **Status:** complete
- Actions taken:
  - Added `ArticleContentFormatter` and wired it into the article reader.
  - Added formatter coverage for headings, emphasis, links, blockquotes,
    mixed inline HTML, rich HTML preservation, and plain prose.
  - Extended the widget journey to verify a Markdown heading renders as HTML.
- Files created/modified:
  - `lib/core/content/article_content_formatter.dart`
  - `lib/features/article/presentation/article_page.dart`
  - `pubspec.yaml`
  - `pubspec.lock`
  - `test/core/content/article_content_formatter_test.dart`
  - `test/widget_test.dart`

### Phase 23: Verify and document Markdown support

- **Status:** complete
- Actions taken:
  - Formatted the project and verified `flutter analyze` has no issues.
  - Ran the complete Flutter suite successfully (40 tests).
  - Documented the display-time conversion and rich-HTML preservation policy.

### Phase 17: Reproduce live removed-entry report

- **Status:** complete
- Actions taken:
  - Fetched `https://cleaver.ca/rss.xml` and compared unconditional and
    validator-backed responses.
  - Inspected `/home/cleaver/Documents/flood.sqlite` without mutating it.
  - Confirmed four absent entries remained unmarked because the server returned
    `304 Not Modified` for a stale ETag.

### Phase 18: Make manual refreshes reliable

- **Status:** complete
- Actions taken:
  - Added an optional forced-refresh mode to the feed repository contract.
  - Wired timeline and subscription refresh actions to bypass stored validators.
  - Added a regression test proving a forced refresh reconciles removals even
    when the validator value is reused.
- Files created/modified:
  - `lib/core/repositories/feed_repository.dart`
  - `lib/core/repositories/drift_feed_repository.dart`
  - `lib/features/subscriptions/presentation/subscriptions_page.dart`
  - `lib/features/timeline/presentation/timeline_page.dart`
  - `test/core/repositories/drift_repositories_test.dart`

### Phase 19: Verify and document the live-feed fix

- **Status:** complete
- Actions taken:
  - Documented the stale-validator behavior and forced manual refresh contract.
  - Ran `flutter analyze` successfully.
  - Ran the focused repository tests and complete suite successfully (35 tests).
- Files created/modified:
  - `README.md`
  - `docs/data-model.md`

### Phase 14: Persist removal state

- **Status:** complete
- Actions taken:
  - Added the `articles.is_removed` column and Drift schema-version-2
    migration.
  - Marked feed entries absent from successful refreshes while retaining rows.
  - Cleared the marker when entries returned and preserved all reader state.
- Files created/modified:
  - `lib/core/database/flood_database.dart`
  - `lib/core/database/flood_database.g.dart`
  - `lib/core/models/article.dart`
  - `lib/core/repositories/drift_article_repository.dart`
  - `lib/core/repositories/drift_feed_repository.dart`
  - `test/core/repositories/drift_repositories_test.dart`

### Phase 15: Explain removal in the UI

- **Status:** complete
- Actions taken:
  - Added a removed-entry icon and tooltip to timeline rows.
  - Added a reader card explaining that the entry is no longer published.
  - Extended the end-to-end widget flow through refresh, timeline, and reader.
- Files created/modified:
  - `lib/features/timeline/presentation/timeline_page.dart`
  - `lib/features/article/presentation/article_page.dart`
  - `test/widget_test.dart`

### Phase 16: Verify and document

- **Status:** complete
- Actions taken:
  - Updated the README and data-model docs with removal semantics.
  - Focused verification passed: analyzer clean and 11 targeted tests passed.
  - Full-suite verification passed: analyzer clean and 34 tests passed.
- Files created/modified:
  - `README.md`
  - `docs/data-model.md`

### Phase 13: Removed-entry history

- **Status:** complete
- Actions taken:
  - Committed the previous Flood implementation as `f315af3`.
  - Started the removed-entry history slice in the same repository.
  - Defined missing entries as retained-but-marked only after a successful
    complete feed response.
  - Confirmed the marker belongs on publisher data and must not overwrite
    reader state.
- Files created/modified:
  - `task_plan.md`
  - `findings.md`

### Phase 10: Ingestion resilience inventory

- **Status:** complete
- Actions taken:
  - Started the resilience coverage slice for offline startup and adverse feed
    inputs.
  - Identified two hardening gaps: the timeout did not cover response bodies,
    and oversize chunks were buffered before rejection.
  - Defined offline startup as serving persisted SQLite data without calling a
    feed source, and duplicate GUID handling as last-occurrence-wins.
- Files created/modified:
  - `task_plan.md`
  - `findings.md`

### Phase 11: Resilience coverage and hardening

- **Status:** complete
- Actions taken:
  - Added a disk-backed offline-startup test that serves persisted data without
    calling a feed source.
  - Covered header/body timeouts, a real local HTTP redirect, invalid XML,
    missing dates, duplicate GUIDs, and oversized response chunks.
  - Extended the fetch deadline to the response body, kept final redirect URLs,
    rejected oversize chunks before buffering, and reconciled duplicate GUIDs.
- Files created/modified:
  - `lib/core/network/feed_document_fetcher.dart`
  - `lib/core/repositories/drift_feed_repository.dart`
  - `test/core/network/feed_document_fetcher_test.dart`
  - `test/core/feed_ingestion/feed_loader_test.dart`
  - `test/core/feed_parsing/feed_document_parser_test.dart`
  - `test/core/repositories/drift_repositories_test.dart`
  - `test/core/repositories/offline_startup_test.dart`

### Phase 12: Verification and documentation

- **Status:** complete
- Actions taken:
  - Ran formatting, static analysis, the focused resilience suite, and the
    complete test suite.
  - Documented offline behavior, deadlines, redirects, response-size limits,
    invalid XML handling, missing dates, and duplicate GUID reconciliation.
- Files created/modified:
  - `README.md`
  - `docs/data-model.md`

### Phase 6: Multi-feed discovery

- **Status:** complete
- Actions taken:
  - Restored the completed one-feed plan and confirmed the new Git baseline is clean.
  - Began the multi-feed reliability slice covering deduplication, filters, starring, and recovery.
  - Found per-feed article uniqueness, existing state filters, and missing recovery controls.
  - Defined URL-based display deduplication while retaining feed membership and syncing reader actions across copies.
- Files created/modified:
  - `task_plan.md`
  - `findings.md`

### Phase 7: Storage and repository hardening

- **Status:** complete
- Actions taken:
  - Added conservative canonical-URL timeline deduplication while retaining
    every per-feed article record.
  - Synced read and starred actions across same-URL copies.
  - Added safe URL replacement, retryable refresh failures, and transactional
    feed removal with its dependent data.
- Files created/modified:
  - `lib/core/utils/article_deduplication_key.dart`
  - `lib/core/repositories/drift_article_repository.dart`
  - `lib/core/repositories/drift_feed_repository.dart`
  - `lib/core/repositories/feed_repository.dart`
  - `test/core/repositories/drift_repositories_test.dart`

### Phase 8: Multi-feed controls and recovery UI

- **Status:** complete
- Actions taken:
  - Added a per-feed timeline selector and direct timeline starring.
  - Added retry, URL editing, and removal controls to subscriptions.
  - Preserved user-entered URLs and enabled a retry action after failed
    subscriptions or URL updates.
- Files created/modified:
  - `lib/features/subscriptions/presentation/subscriptions_page.dart`
  - `lib/features/timeline/presentation/timeline_page.dart`

### Phase 9: Verification and documentation

- **Status:** complete
- Actions taken:
  - Ran formatting, static analysis, and all tests.
  - Updated the README and data-model document for multi-feed behavior.
- Files created/modified:
  - `README.md`
  - `docs/data-model.md`

### Phase 1: Discovery

- **Status:** complete
- Actions taken:
  - Created a persistent plan for the first end-to-end feed slice.
  - Inspected existing ingestion, domain, repository, and UI boundaries.
  - Verified current persistence, HTML rendering, and URL-launch packages.
- Files created/modified:
  - `task_plan.md`
  - `findings.md`
  - `progress.md`

### Phase 2: Persistence and repositories

- **Status:** complete
- Actions taken:
  - Selected Drift with an injected executor for production and tests.
  - Added generated Drift schema and production repository implementations.
  - Added transactional subscribe/refresh and reader-state preservation.
- Files created/modified:
  - `lib/core/database/flood_database.dart`
  - `lib/core/database/flood_database.g.dart`
  - `lib/core/repositories/drift_feed_repository.dart`
  - `lib/core/repositories/drift_article_repository.dart`
  - `test/core/repositories/drift_repositories_test.dart`

### Phase 3: Subscription and timeline UI

- **Status:** complete
- Actions taken:
  - Composed the production database, network client, loader, and repositories.
  - Added feed URL validation, subscription progress, refresh actions, and errors.
  - Added reactive feed and timeline views with All, Unread, and Saved filters.
- Files created/modified:
  - `lib/app.dart`
  - `lib/app_dependencies.dart`
  - `lib/features/app_shell/presentation/app_shell.dart`
  - `lib/features/subscriptions/presentation/subscriptions_page.dart`
  - `lib/features/timeline/presentation/timeline_page.dart`

### Phase 4: Article reading state

- **Status:** complete
- Actions taken:
  - Added navigation into an HTML article reader.
  - Marked articles read on open and persisted saved state.
  - Added support for opening original article URLs.
- Files created/modified:
  - `lib/features/article/presentation/article_page.dart`
  - `test/widget_test.dart`

### Phase 5: Verification and delivery

- **Status:** complete
- Actions taken:
  - Added Android network permission for production feed requests.
  - Documented the working vertical slice and Drift generation command.
  - Formatted all Dart files, ran static analysis, and ran the full test suite.
- Files created/modified:
  - `android/app/src/main/AndroidManifest.xml`
  - `README.md`

## Test Results

| Test | Expected | Actual | Status |
|---|---|---|---|
| Baseline from previous phase | 16 tests pass | 16 tests passed | ✓ |
| Drift repositories | Subscribe, refresh, state preservation, filters | 4 tests passed | ✓ |
| Full verification | Analyzer and all unit/repository/widget tests | No analyzer issues; 20 tests passed | ✓ |
| Multi-feed verification | Analyzer and repository/widget integration tests | No analyzer issues; 23 tests passed | ✓ |
| Resilience verification | Analyzer and complete test suite | No analyzer issues; 32 tests passed | ✓ |
| Removed-entry verification | Analyzer and complete test suite | No analyzer issues; 34 tests passed | ✓ |

## Error Log

| Timestamp | Error | Attempt | Resolution |
|---|---|---:|---|
| 2026-09-09 | Planning-file patch context changed | 1 | Re-read the files and narrowed the patch |
| 2026-09-09 | Build runner stopped after 30 seconds compiling builders | 1 | Retry in an attached session that can be polled |
| 2026-09-09 | Three `prefer_initializing_formals` analyzer notices | 1 | Used positional initializing formals for injected dependencies |
| 2026-09-09 | Dependency-container patch was truncated | 1 | Confirmed no partial file existed and rebuilt the patch |
| 2026-09-09 | Error-log patch context mismatch | 1 | Re-read plan before updating |
| 2026-09-09 | Invalid working directory in inspection command | 1 | Used the verified project path |
| 2026-09-09 | Combined UI patch was truncated | 2 | Switched to one-file patches |
| 2026-09-09 | Dependency-container import typo | 1 | Corrected before analysis |
| 2026-09-09 | Article-page patch wrapper syntax error | 1 | Reissued as a clean one-file patch |
| 2026-09-09 | `prefer_initializing_formals` notice | 1 | Used a public initializing formal for the callback |
| 2026-09-09 | UI patch targeted files twice in one diff | 1 | Split delete and add operations |
| 2026-09-09 | Reader test could not find HTML output as a plain `Text` widget | 1 | Assert the `HtmlWidget` source content instead |
| 2026-09-09 | End-to-end test kept settling after the reader-state update | 1 | Use deterministic bounded frame pumps |
| 2026-09-09 | Manual widget teardown hung while replacing the async HTML reader | 2 | Let the test binding dispose the widget tree after the assertion |
| 2026-09-09 | One-shot repository watch left cancellation pending in the widget test | 1 | Verify persisted state with a direct database read |
| 2026-09-09 | Drift deferred stream cleanup left a pending zero-duration timer | 1 | Configure synchronous stream closure for the test connection and close it explicitly |
| 2026-09-09 | Drift and matcher exported conflicting `isNotNull` symbols | 1 | Hide the SQL symbol from the Drift test import |
| 2026-09-09 | Final status check assumed Git metadata existed | 1 | Reviewed files directly; the project directory is not a Git repository |
| 2026-09-09 | Feed URL normalization emitted a trailing `#` | 1 | Use a null fragment when rebuilding the URI |
| 2026-09-09 | Redirect source URI remained at the original request URL | 1 | Use `BaseResponseWithUrl` for the final redirect destination |
| 2026-09-10 | Removed-entry widget test looked for `Today` as a navigation label | 1 | Use the shell's `Timeline` destination label |

## 5-Question Reboot Check

| Question | Answer |
|---|---|
| Where am I? | Complete |
| Where am I going? | Ready for the next product slice |
| What's the goal? | Resilience coverage for offline and hostile feed inputs |
| What have I learned? | See `findings.md` |
| What have I done? | Delivered and verified ingestion resilience coverage |

## Session: 2026-09-10 — Desktop window-size persistence plan

### Phase 24: Discover window persistence boundary

- **Status:** complete
- Actions taken:
  - Inspected the active Flood source tree and confirmed it is a Flutter
    desktop-capable app.
  - Located the hard-coded 1280×720 defaults in the Linux and Windows runners.
  - Confirmed `main.dart` has no window initialization and `pubspec.yaml` has
    no window or preferences package.
  - Chose a desktop-only `window_manager` plus `shared_preferences` design,
    separate from the Drift content database.
- Files created/modified:
  - `task_plan.md`
  - `findings.md`
  - `progress.md`

### Planned next phases

- Phase 25: implement the validated width/height store.
- Phase 26: integrate startup, resize debounce, and close flushing.
- Phase 27: test and document desktop behavior.

### Phase 25: Persisted window state

- **Status:** complete
- Actions taken:
  - Began implementation from the approved desktop-only design.
  - Added `window_manager` and `shared_preferences`.
  - Added validated `WindowSizePolicy` and a SharedPreferences-backed store.
  - Added an injectable desktop window controller with debounced resize saves
    and close-time flushing.
  - Added focused policy, storage, and lifecycle tests; all 11 passed.
- Files created/modified:
  - `pubspec.yaml`
  - `pubspec.lock`
  - `lib/main.dart`
  - `lib/core/window/window_size_store.dart`
  - `lib/core/window/desktop_window_controller.dart`
  - `lib/core/window/window_bootstrap.dart`
  - `lib/core/window/window_bootstrap_io.dart`
  - `lib/core/window/window_bootstrap_stub.dart`
  - `test/core/window/window_size_store_test.dart`
  - `test/core/window/desktop_window_controller_test.dart`

### Phase 26: Integrate startup and resize lifecycle

- **Status:** complete
- Actions taken:
  - Confirmed Flutter generated `window_manager` registration for Linux,
    Windows, and macOS.
  - Built and launched the Linux app with the new bootstrap.
  - Verified clean runtime startup, the Flood window title, and persisted
    width/height preference keys.
  - Covered resize, maximize/fullscreen, relaunch, and close behavior with the
    injected controller tests.

### Phase 27: Verify and document window persistence

- **Status:** complete
- Actions taken:
  - Added the desktop behavior section to `README.md`.
  - Ran `dart format`, `flutter analyze`, `flutter test`, and
    `flutter build linux --debug` successfully.
  - Ran `flutter build web` successfully to verify the conditional no-op path.
  - Full test result: 50 tests passed.
  - Recorded that interactive Windows/macOS smoke testing is not available on
    the current Linux-only development target.
- Files created/modified:
  - `README.md`
  - `task_plan.md`
  - `findings.md`
  - `progress.md`

## Session: 2026-09-11 — Design review

Reviewed theme, shell, all screens and product brief. Preparing recommendations only. Existing uncommitted window-persistence work preserved.

Completed `docs/design-review.md`, covering layout, colour, typography, reader, subscriptions, settings, states, accessibility, and implementation priorities. Verified recommendations against presentation source and model fields. No application code changed; no runtime visual validation or tests performed for this documentation-only review.

Incorporated user preference for dark app chrome with an independently selectable white article canvas into the design review.
