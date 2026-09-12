# Task Plan

## Goal

Make Flood's article viewer calm and comfortable to read, with a constrained
column and two selectable font combinations. The default uses editorial serif
prose and sans-serif display text; the alternative uses sans-serif prose.
Remember the choice across articles and launches and retain offline content,
reader actions, and independent article appearance.

## Phases

- [x] Phase 1 — Inspect the viewer, design guide, content pipeline, preferences,
  and existing tests; choose two bundled font combinations.
- [x] Phase 2 — Write and run focused rendered-behavior tests; confirm failures
  for wide content, missing font selection, and publisher color overrides.
- [x] Phase 3 — Implement the first reader layout, typography, HTML normalization,
  font selector with previews, and persisted font preference.
- [x] Phase 4 — Complete regression coverage and resolve integration failures:
  persistence, retained scroll position, rich content, missing content, long
  titles, appearance switching, narrow/wide layouts, and enlarged text.
- [~] Phase 5 — Inspect actual rendering in both font combinations, light/dark/
  white-article appearances, narrow and wide layouts, and 640×480 minimum.
  Responsive rendered behavior and appearance switching are covered by widget
  tests; full-frame raster capture hung in this runner, so manual visual review
  remains to be done in a desktop session.
- [x] Phase 6 — Document fonts and behavior, run `dart format lib test`,
  `flutter analyze`, `flutter test`, and `git diff --check`; review final diff
  and hand off with automated and visual verification distinguished.

## Decisions

- Editorial default: Source Serif 4 prose with Inter titles and headings.
- Sans serif alternative: Inter prose with the same Inter display hierarchy.
- Bundle upright and italic variable fonts and their licenses for offline use.
- Use a 680 logical-pixel maximum column, 19 px body at 1.6 line height,
  responsive 28–34 px title, 13 px metadata, and consistent block spacing.
- Put both choices and short font samples in the existing Article appearance
  sheet. Save the font choice through a separate preferences store using the
  existing shared_preferences dependency.
- Normalize a display-only HTML copy, preserving semantic markup and original
  stored content. Declare the already-transitive html package directly.
- Reuse the HTML renderer's local scrolling for code/tables. Keep reader palette
  separate from app chrome; use a flat opaque canvas and semantic colors.
- User requested `$codex-planning-with-files` after implementation began.
  Maintain these files using that skill; earlier archived plans are historical.

## Errors Encountered

| Error | Attempt | Resolution |
|---|---:|---|
| Initial reader tests: 1240 px prose width, missing Sans serif option, unchanged publisher yellow after appearance switch | 1 | Expected red phase; all three tests now pass |
| Existing app widget test times out opening article | 1 | Resolved by removing the preference loading gate so cached content renders immediately |
| SharedPreferences loading blocked cached article rendering in plugin-less tests | 1 | Removed the render gate; use editorial defaults while loading asynchronously |
| Flutter full-frame screenshot smoke test hung during `RenderRepaintBoundary.toImage` in this runner | 1 | Removed temporary test; rely on rendered widget assertions and report visual limitation |
