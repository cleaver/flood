# Progress — Flood design review

## September 11, 2026 — Review and recommendations

- Reviewed the theme, app shell, all presentation screens and dialogs, product
  brief, and article model.
- Created [docs/design-review.md](docs/design-review.md), covering colour,
  layout, typography, reader presentation, subscriptions, settings,
  accessibility, and interaction states.
- Checked recommendations against source and available model fields.
- Incorporated the user's preference for app dark mode with an independently
  selectable white article background.
- Recorded the user's clarification that this is exploratory work and that
  implementation should wait while the ideas are considered.

The source-based review is complete. Implementation began after the user's
request; runtime visual validation remains outstanding.

## September 11, 2026 — Independent planning files

- Recreated root-level `findings.md`, `progress.md`, and `task_plan.md` with
  design-review content only after the previous combined history was archived.
- Kept the existing detailed review and archived planning history intact.
- Distinguished confirmed user preferences from proposed design details.

## Current status

Implementation is now in progress at the user's request.

## September 11, 2026 — Design implementation

- Fast-forwarded `main` from upstream (`289c981`), including macOS entitlement
  fixes.
- Added explicit light/dark surface, app bar, and divider styling.
- Renamed the timeline heading to “Timeline” and added calmer row padding.
- Added an article appearance bottom sheet with a white article canvas option;
  app chrome remains on the app theme.
- `flutter analyze` passes and all tests pass.

## September 11, 2026 — White reader background fix

- Diagnosed the reported Linux appearance issue: the nested reader theme changed
  text styling, but the outer `Scaffold` still painted the app background and
  the transparent list revealed it.
- Added an explicit `ColoredBox` around the reader content using the selected
  reader theme surface colour.
- `flutter analyze` and the article widget test pass.
