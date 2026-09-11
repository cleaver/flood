# Findings — Flood design review

## Scope and evidence

The September 11, 2026 review examined the app theme, shell, timeline, article
reader, subscriptions and dialogs, settings, product brief, and article model.
Findings come from source inspection; no running UI or screenshots were
inspected. Rendering, font metrics, hover behaviour, and contrast remain
unvalidated.

The detailed review is in [docs/design-review.md](docs/design-review.md).

## Observations

- Generated Material 3 colour schemes and default controls give the app a
  generic appearance. Changing the seed colour alone would not address layout
  or typography.
- Bottom navigation is used at every window size. Lists and article content
  fill the available width without a desktop-specific reading layout.
- Timeline rows omit available dates and summaries and show persistent status
  circles and star controls. The heading “Today” is not backed by a date filter.
- The reader lacks a maximum text width and an explicit reading type system.
- Subscription rows repeat RSS icons, full URLs, and action buttons; dialogs
  and empty states could communicate intent more clearly.
- Settings rows are static. “In app” contradicts external link launching, and
  the displayed retention value should not imply an implemented preference.

## Confirmed user preferences

- Keep app dark mode available.
- Allow users to choose a white article background independently of app
  appearance, with appropriate dark text and reader content colours.
- This remains idea gathering. The user wants to ruminate before building;
  recommendations are not an approved implementation plan.

## Proposed direction — open for discussion

- Quiet editorial styling: neutral surfaces, clear text hierarchy, and a crisp
  blue accent used sparingly.
- Adaptive desktop sidebar, article list, and reader; simpler navigation at
  narrow widths and on phones.
- Intentional article rows with dates, optional excerpts, restrained status
  indicators, and accessible save actions.
- A constrained reading column with consistent HTML typography and spacing.
- Independent app and reader appearance preferences. Suggested options are
  System/Light/Dark for the app and Follow App/White/Dark for articles; exact
  controls, defaults, and persistence behaviour remain proposals.
- More focused subscription flows, truthful settings, useful empty/error
  states, and keyboard/text-scaling accessibility.

Palette values, dimensions, fonts, component choices, and implementation order
in the review are starting points, not settled decisions.

## Reference and limitations

The Apple materials search result described Liquid Glass for controls and
navigation: [Apple materials guidance](https://developer.apple.com/design/human-interface-guidelines/materials).
Direct guideline page reads required JavaScript, so the review did not rely on
unavailable page bodies. Restrained optional translucency is a design proposal;
recreating glass effects is not a requirement.
