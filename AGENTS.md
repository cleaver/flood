# Working on Flood

Flood is a calm, local-first RSS reader built with Flutter and Dart.

## Read only what the task needs

- UI changes: read [the design guide](docs/design-guide.md).
- Product scope: consult [the product brief](docs/product-brief.md).
- Persistence changes: consult [the data model](docs/data-model.md).
- Setup and supported behaviour: see [README.md](README.md).
- Archived plans and the design review are historical context, not active tasks.

## Implementation

- Follow existing feature structure and repository interfaces. Keep database,
  network, and feed-processing logic out of presentation widgets.
- Preserve offline reading, stored content, and reader state across refreshes.
- Reuse existing components and dependencies; justify additions with a concrete
  need. Keep changes within the requested scope and preserve unrelated edits.
- Regenerate generated code using its tooling; do not edit it by hand.

## Red / green / refactor

- For new behaviour and bug fixes, first write a focused test that exercises
  the real user-visible or repository behaviour. Run it and confirm it fails
  for the intended reason.
- Implement the smallest coherent change that makes it pass, then refactor
  with tests green. Avoid tests that merely repeat implementation details.
- For UI bugs, assert rendered behaviour where practical; checking a widget's
  input property alone may miss inheritance, caching, or painting problems.
- Documentation and purely visual changes need proportionate review or visual
  checks rather than artificial unit tests. State any verification limits.

## Before handoff

- For code changes, run `dart format lib test`, `flutter analyze`, and relevant
  tests while iterating; run `flutter test` before handoff.
- For UI changes, check the appearance and layout cases in the design guide.
- Review `git diff --check` and the final diff for accidental scope changes.
- Report what changed, what was tested, and what remains. Distinguish automated
  checks from visual verification; do not call a partial implementation complete.
