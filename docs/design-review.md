# Flood design review

September 11, 2026. Recommendations for discussion, not an implementation specification.

## Direction

Give Flood a **quiet editorial** identity: a paper-white reading surface, soft grey navigation, strong text hierarchy, and a clear blue accent. Aim for the composure of a desktop reading application, with navigation adapted for small screens.

The current design feels generic because almost every visual decision is inherited from Material defaults. Changing the seed colour alone would leave the same navigation, spacing, row anatomy, dialogs, and reading layout.

This review covers `lib/app.dart` and every presentation file: app shell, timeline, article, subscriptions including dialogs, and settings. It also considers the product brief and article model. Findings are based on source inspection; actual rendering, hover behaviour, font metrics, and contrast still need visual validation. No running app or screenshots were inspected.

## Confirmed preference: independent reader appearance

Keep dark mode available for the app, with a separate option to read articles on a white background.

- **App appearance:** System / Light / Dark.
- **Article appearance:** Follow App / White / Dark. Default to Follow App until the user chooses otherwise.
- Choosing White gives the article canvas, title, metadata, and content a white surface with appropriate dark text. The sidebar, article list, and reader toolbar continue to follow app appearance.
- Persist the reader choice globally across articles and restarts. Make it available from Settings and the reader appearance control; both edit the same preference.
- Apply a complete reader palette, including links, quotes, code, tables, and content placeholders. A white background alone would leave inherited dark-mode text unreadable. Check publisher-supplied foreground/background styling and preserve useful content formatting.
- Verify Dark App + White Article explicitly, including selection colours, links, code blocks, and the boundary between dark chrome and the white reading canvas.

## 1. Layout and navigation — highest impact

**Current:** `AppShell` uses a bottom `NavigationBar` at every size. Each destination fills the window; opening an article replaces the view with a separate route. The desktop fallback is 1280×720, where this layout leaves considerable space without adding useful context.

**Recommend:**

- Wide desktop: a sidebar, article list, and reading pane. Start around 220 / 340 / remaining logical pixels. At 1280 pixels this leaves about 720 for the reader, before dividers.
- Medium windows: a collapsible sidebar and list/reader navigation, or two panes where content fits. Do not squeeze three columns into the supported 640-pixel minimum width.
- Phone: a compact tab bar and a pushed article page. Keep familiar back navigation and preserve list position.
- Sidebar: Timeline, Unread, Saved; then feed subscriptions. Keep Add Feed near the feed section and Settings at the bottom. On mobile retain Timeline, Feeds, Settings, with All/Unread/Saved inside Timeline.
- In a desktop sidebar layout, remove the redundant All/Unread/Saved segmented control from the list toolbar.
- Display the active feed name visibly in the list heading. The current generic filter icon gives little feedback about the selected feed.

Determine breakpoints by minimum usable column widths and scaled text, rather than device labels. Selecting an article should leave the desktop list available and show a clear selected row distinct from unread state.

## 2. Colour — crisp neutrals with one accent

**Current:** `ColorScheme.fromSeed` generates light and dark schemes from muted blue seeds. Surface, selection, and control colours are largely implicit.

Use explicit semantic tokens. These are starting swatches, not measured accessibility guarantees or exact Apple system colours:

| Role | Light | Dark |
|---|---|---|
| Main reading surface | `#FFFFFF` | `#191A1C` |
| Navigation/background | `#F4F5F7` | `#111214` |
| Elevated panel | `#FFFFFF` | `#24262A` |
| Primary text | `#202124` | `#F2F3F5` |
| Secondary text | `#626874` | `#A5ABB5` |
| Accent/link | `#0066CC` | `#66ADFF` |
| Subtle selected row | `#E8F1FC` | `#20364F` |
| Decorative separator | `#E4E6EA` | `#33363B` |

Use blue for links, active controls, unread dots, and focus. Let typography and surface differences carry most hierarchy. Give warnings and destructive actions separate semantic colours; an article disappearing from its publisher's feed is informational, not a red error.

My preferred palette is the blue above: it feels clear and suits Flood's name. A teal accent could give it more individuality, but I would settle the neutral surfaces and hierarchy before exploring accent variants.

## 3. Timeline rows — make the articles the visual focus

**Current:** a standard `ListTile` contains a read/unread circle, title, feed name, and permanently visible star button. Dividers span the full width. Publication times and summaries are omitted, despite fields existing in the model.

Replace it with an intentional article row:

- A small source icon or monogram beside source name and a quiet date/time.
- A two- or three-line title with a controlled line height. Use approximately 16–17 logical pixels on desktop, a little larger on phone, as a starting point.
- Optional one- or two-line plain-text excerpt where useful. Extract readable text from supplied summaries; never display raw markup.
- A small blue unread dot. Remove the outlined circle for read entries; retain readable title contrast and reduce weight instead.
- Show a bookmark when saved. On desktop, expose the unsaved action on hover **and keyboard focus**, with a context menu. On touch, retain an accessible save action through a visible menu or swipe action.
- Use inset separators aligned to the text, and deliberate vertical padding. Avoid turning every article into a raised card.

Use “Timeline” or “All Articles” for the current heading. “Today” presently implies a date filter that does not exist. Date grouping can use Today, Yesterday, and Earlier; missing publication dates must not be presented as known publication times.

Thumbnails are optional later work. The current model has no dedicated thumbnail field, and image-free feeds should remain first-class. A consistent text-first list suits the product brief.

## 4. Reader — the main product experience

**Current:** the reader has 20-pixel horizontal padding, no maximum content width, a default `headlineMedium` title, a divider, and an `HtmlWidget` with no explicit reading typography.

- Centre a reading column approximately 640–720 logical pixels wide, aiming for roughly 60–75 characters per line. Reduce margins naturally in narrow panes.
- Start with 18-pixel body text and 1.55–1.65 line height; offer text-size adjustment. Treat these as prototype values to validate against real feed content.
- Use a strong 28–34-pixel article title, followed by source, author when available, and publication date. Let spacing separate the header from the body instead of the current prominent divider.
- Keep UI typography in a platform-appropriate sans serif. Offer a serif reading face as an optional preference rather than imposing it on technical content.
- Define paragraphs, heading rhythm, quotes, links, lists, code blocks, tables, and images as one reader style. Allow wide code/tables to scroll locally without widening the entire page.
- Put save/bookmark, open original, and reading appearance in a restrained toolbar. Share and mark unread are worthwhile follow-up interactions, but need real behaviour behind their controls.
- Replace the removed-entry card and red icon with a compact neutral note: “No longer in this feed. Your downloaded copy is still available.”
- When supplied content is absent, show a useful explanation and an Open Original button when a URL exists.

Keep the existing Markdown/HTML formatting boundary. This work concerns presentation; it does not require changing stored feed content or adding full-text scraping.

## 5. Subscriptions and dialogs

**Current:** repeated RSS icons, full feed URLs, refresh and overflow buttons on every row, plus a floating Add button. Add/edit uses a Material `AlertDialog` and text field. The empty state duplicates the add action.

- Use feed identity: favicon when available, a monogram otherwise. Show a short host name beneath the title; keep the full feed URL in feed details/editing.
- Put Add Feed in the toolbar. A plus action belongs naturally beside the collection it modifies.
- Move routine per-feed refresh into the context menu; show Retry visibly for failed feeds.
- Translate raw refresh errors into short actionable messages, with technical detail available on demand.
- Use a focused sheet for adding/editing on phone and a compact dialog on desktop: title, short help text, URL input, Cancel, Subscribe. Keep errors next to the input and make progress explicit.
- Retain the existing removal confirmation and its explanation that downloaded articles are deleted. Style Remove as destructive, with an ordinary Cancel action.
- After subscribing, land on the newly added feed or visibly identify what was added; the current jump to the unfiltered timeline can lose context.

## 6. Settings must be truthful

The three settings rows are static. “Open original links: In app” contradicts the reader's external-application launch mode. “Downloaded articles: 30 days” presents a retention promise that this screen does not implement.

Before cosmetic changes, remove unsupported values or wire them to real preferences. Then use grouped settings sections with clear labels, values, and disclosure indicators only where rows are actionable.

Useful first controls are App Appearance (System/Light/Dark), Article Appearance (Follow App/White/Dark), reader text size, and reader font. Independent article appearance is a confirmed user requirement. Describe external link behaviour accurately. Retention/data controls should be introduced alongside their real implementation and deletion semantics.

## 7. Empty, loading, error, and interaction states

- No subscriptions: explain the next step and offer Add Feed.
- No unread articles: “You're caught up,” with a route to all articles.
- No saved articles: explain saving/bookmarking.
- Empty selected feed: identify that feed and offer refresh where appropriate.
- Refresh failure: identify affected feeds and provide Retry/details. Keep cached content visible.
- Show refresh progress and a truthful last-updated status. Avoid a large blocking spinner when cached content exists.
- Keep the reader toolbar/back route available during errors; its current error scaffold has no app bar.
- Support keyboard traversal, visible focus, selection, context menus, tooltips, and platform-appropriate shortcuts on desktop. Hover cannot be the only way to discover an action.
- Honour text scaling and reduced motion. Start with at least 44-logical-pixel touch targets and verify actual hit regions.
- Validate text contrast in both themes, selected/read/unread combinations, and high-contrast settings. Never encode state with colour alone.

## 8. What “Apple-like” should mean here

For Flood, the useful qualities are restrained controls, recognisable navigation, readable typography, coherent spacing, and responsiveness to input and window size.

Apple's current materials guidance describes Liquid Glass as a control/navigation material. My recommendation is to keep article surfaces opaque and consider restrained translucency for chrome only after the underlying layout works. A custom glass renderer would be a poor first investment for this Flutter app. Reference: [Apple materials guidance](https://developer.apple.com/design/human-interface-guidelines/materials).

Use platform-appropriate dialogs and transitions where practical. Cupertino components can contribute to an iOS presentation, but wholesale replacement would not resolve desktop layout or reading typography. A small Flood component layer can provide shared colours, spacing, article rows, toolbars, and state views while preserving platform conventions.

Standardise icon size and stroke weight. Prefer a bookmark for Saved consistently across navigation, list, and reader. Do not assume Apple fonts or symbol assets can simply be bundled across every target; choose assets and fallbacks suitable for the supported platforms.

## Recommended sequence

1. **Visual foundation:** explicit light/dark tokens, type scale, spacing, icon conventions, consistent controls; fix misleading labels and settings. Moderate effort, immediate coherence.
2. **Reading experience:** constrained reader, HTML styles, article row redesign, useful empty/error states. Moderate effort, high benefit on every platform.
3. **Adaptive desktop shell:** sidebar, list/reader split, collapse rules, selection and keyboard behaviour. Larger effort, greatest desktop improvement.
4. **Finishing pass:** subscription sheets, feed identity, shortcuts, subtle motion, optional material effects. Feed imagery and new preferences need implementation beyond styling.

The first design checkpoint should show a populated desktop timeline with an article open, the same reading flow on phone, and both colour modes. Validate long titles, missing dates/content, code-heavy articles, feed failures, 640×480 windows, and enlarged text. These are proposed validation cases, not tests already performed.
