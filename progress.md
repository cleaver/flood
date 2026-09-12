# Progress

## Session Log

### 2026-09-11 — Reader typography and layout

- Inspected the current viewer, app themes, content formatter, dependencies,
  widget tests, design guide, product brief, README, and data model.
- User approved two combinations: serif prose/sans display as default and an
  alternative with sans prose. Selected Source Serif 4 and Inter; bundled fonts.
- Added three rendered-behavior tests before implementation. Confirmed expected
  failures for unconstrained width, absent selection, and publisher color leakage.
- Implemented initial reader styles, responsive column, appearance-sheet font
  previews, font preference store, and display-only HTML normalization.
- Ran focused article tests plus existing app widget test: 3 passed; existing
  app widget test timed out opening an article. Full checks and visual QA pending.
- User requested file-based planning. Found and fully read
  `/home/cleaver/.codex/skills/codex-planning-with-files/SKILL.md` and its templates;
  created these three root planning files without changing archived plans.
- Removed the preference loading gate so cached article content renders
  immediately; the existing app widget test now passes.
- Added scroll controller restoration and debounced persistence through the
  existing ArticleRepository state contract. Added tests for initial offset and
  saved offset.
- Added direct tests for font preference defaults, round-trip persistence,
  unknown values, and display-only HTML normalization.
- Added bundled-font provenance and license notes under `assets/fonts`.
- `flutter analyze` passes. Targeted content, preference, reader, and app widget
  tests pass: 8 tests total.
- Added responsive tests for long titles, missing content at the 640×480
  minimum, and enlarged text. All reader tests pass: 8 tests total.
- Attempted a Flutter full-frame screenshot smoke test for editorial and sans
  states; `RenderRepaintBoundary.toImage` hung in this runner before producing
  an image. Removed the temporary test; visual verification remains limited.
- Ran the complete final checks: `dart format lib test`, `flutter analyze`,
  `flutter test` (59 passed), `flutter build linux --debug`, and `git diff --check`.
- Reviewed the final diff and confirmed only the reader implementation, bundled
  fonts, direct HTML dependency, tests, README, and requested planning files are
  changed.

Implementation is complete. A manual desktop visual pass remains because the
headless full-frame raster capture path is unavailable in this runner.
