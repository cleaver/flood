# Flood design review archive

## Dates

- Plan created: September 11, 2026, during the design review and first
  implementation pass.
- Plan archived: September 11, 2026.

## Purpose

Explore a more polished, Apple-inspired Flood interface while explicitly
avoiding a Liquid Glass visual direction. Capture recommendations for layout,
colour, typography, reading surfaces, navigation, subscriptions, settings, and
accessibility.

## Accomplished

- Reviewed the theme, shell, timeline, reader, subscriptions, dialogs,
  settings, product brief, and article model.
- Documented a quiet editorial direction and adaptive layout recommendations.
- Preserved app dark mode and added a separate white article reading surface.
- Added explicit light/dark surface styling and a clearer Timeline heading.
- Fixed the white reader canvas and cached dark-theme HTML text colours.
- Added widget regression coverage; `flutter analyze` and the full test suite
  pass.

## Relevant commits

- `91e41d8` — add UI design review
- `ec22592` — refine reader appearance
- `6e9e265` — refresh text style on appearance
- `289c981` — allow outgoing feed connections

The original root planning files remain in place until explicitly deleted.
