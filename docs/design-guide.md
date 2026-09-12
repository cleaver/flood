# Flood design guide

Use this guide for UI changes. It defines the design direction; it does not
require implementing every recommendation in a single task.

## Character

- Calm, editorial, and Apple-inspired: clear hierarchy, readable content,
  restrained controls, and deliberate spacing.
- Use opaque surfaces. No Liquid Glass, background blur, glass effects, or
  decorative translucency. Respect each platform's navigation and input habits.
- Prefer subtle separators and surface differences over raised cards everywhere.

## Colour and reading appearance

- Use shared semantic theme tokens for surfaces, text, accent, selection,
  separators, and status. Keep palette values out of individual widgets.
- Use neutral surfaces and a restrained blue accent. Reserve error colours for
  failures and destructive actions; ordinary article status should stay quiet.
- Keep app and article appearance independent. A white article in a dark app
  must have an opaque white canvas and dark text while app chrome stays dark.
- Apply the reader palette to titles, metadata, HTML, links, lists, code, tables,
  placeholders, and selection. Check rendered output when appearance changes;
  a nested theme alone may not update inherited or cached styles.
- Maintain readable contrast in every supported appearance; never convey state
  solely through colour.

## Typography and layout

- Use a small shared type and spacing scale. Make titles, body text, and metadata
  distinct; use a consistent icon family, size, and weight.
- Constrain reading width, aiming for roughly 60–75 characters per line with
  comfortable line spacing. These are tuning targets, not rigid pixel rules.
- Adapt to available width and text scaling. Wide windows can expose navigation,
  list, and reader together; narrow windows need clear transitions and back paths.
- Preserve list position and reading context. Keep oversized code and tables
  locally scrollable rather than widening the entire page.

## Components and interaction

- Reuse shared controls. Keep primary actions discoverable and secondary actions
  restrained; hover must never be the only way to reach an action.
- Distinguish selected, unread, and saved states. Use consistent labels and
  icon meanings across navigation, lists, and the reader.
- Provide useful loading, empty, and error states with a next action where
  appropriate. Keep cached content visible during refreshes and failures.
- Settings and status labels must describe real behaviour. Do not present
  placeholder values as working preferences or promises.
- Support keyboard navigation, visible focus, accessible names, text scaling,
  reduced motion, and generous touch targets (aim for at least 44 logical pixels).

## Verify UI changes

- Check light app, dark app, and dark app with white article, including switching
  appearance while content is already displayed.
- Check narrow and wide layouts, the supported 640×480 desktop minimum, and
  enlarged text for overflow and unreachable controls.
- Exercise relevant long titles, missing content, rich HTML/code, empty lists,
  failures, keyboard focus, and read/saved/selected combinations.
- Inspect actual rendering when possible and report which platforms and cases
  were checked. Automated tests do not substitute for unperformed visual review.

The [design review](design-review.md) contains broader ideas and historical
context. Where it suggests optional translucency, this guide supersedes it.
