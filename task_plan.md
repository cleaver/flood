# Task plan — Flood design review

## Objective

Explore how Flood could feel more polished and Apple-like, and document
concrete recommendations across its design and layout.

## Current status

Review complete; ideas under consideration. The user wants to ruminate before
building. This file tracks the design discussion only and does not authorize
implementation.

## Completed review

- [x] Inspect the theme, navigation, all screens, dialogs, and product context.
- [x] Identify opportunities in colour, typography, layout, and interaction.
- [x] Document recommendations in `docs/design-review.md`.
- [x] Capture independent article appearance: retain app dark mode while
  allowing white-background article reading.
- [x] Record evidence limitations and distinguish proposals from decisions.
- [x] Restore independent design-only planning files after reorganization.

## Implementation — 2026-09-11

- [x] Pull upstream changes with fast-forward only.
- [x] Add explicit calm light/dark surface and divider theme tokens.
- [x] Rename the misleading Timeline heading from “Today”.
- [x] Add a reader appearance sheet with Follow app appearance and White
  article options, keeping the article canvas independent from app chrome.
- [x] Format, analyze, and run the complete test suite.
- [x] Fix the reader surface so White article paints an opaque white canvas.

## Constraints and preferences

- Preserve dark mode as an app option.
- Support an independently selectable white article surface in the proposed
  design, with suitable text and content colours.
- Keep the work exploratory until the user chooses to proceed.
- Palette, layout dimensions, appearance controls, and implementation sequence
  remain open for discussion.

## Possible future discussion

These are discussion topics, not queued implementation tasks:

- Settle the visual direction, palette, and typography.
- Compare desktop navigation and reading layouts.
- Refine the boundary between app appearance and article appearance.
- Decide whether visual mockups would help evaluate alternatives.
- Choose a scope and validation approach if implementation is requested.

## Documents

- [Detailed design review](docs/design-review.md)
- [Findings and preferences](findings.md)
- [Review progress](progress.md)
