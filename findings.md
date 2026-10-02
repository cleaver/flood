# Findings

- `article_page.dart` originally used a full-width ListView with 20 px side
  padding, Material bodyLarge text, and 1.6 line height. There was no font choice.
- The design guide calls for roughly 60–75 characters per line, opaque surfaces,
  independent article colors, responsive text scaling, and local overflow for
  code/tables. Its visual matrix includes 640×480 and white articles in dark apps.
- The HTML renderer applies element styles after customStylesBuilder, so custom
  defaults alone cannot reliably override publisher typography or colors.
- The renderer already wraps preformatted content and wide tables in horizontal
  scroll views. Reuse this behavior rather than replacing semantic HTML widgets.
- ArticleContentFormatter preserves rich HTML and converts recognizable Markdown.
  ReaderHtmlNormalizer is a separate display-only step; database content is intact.
- The shared_preferences package already exists for desktop window preferences.
  Font preferences need no schema migration and should stay outside widgets.
- Source Serif 4 and Inter have upright/italic variable fonts and SIL OFL licenses.
  Sources: https://github.com/google/fonts/tree/main/ofl/sourceserif4 and
  https://github.com/google/fonts/tree/main/ofl/inter. Font files and licenses
  downloaded from those source directories; record provenance in assets/fonts.
- W3C visual presentation guidance supports constrained line length, generous
  leading, and left alignment; exact Flood dimensions are design starting points,
  not a claim of complete accessibility conformance:
  https://www.w3.org/WAI/WCAG22/Understanding/visual-presentation.html.
- New tests inspect effective text styles on RenderParagraph spans, not just
  HtmlWidget inputs, to catch inheritance and cached-rendering regressions.
- T3 collaborative preview tools are available if browser verification is useful;
  prefer them for browser work. Flutter widget rendering can also provide evidence.

---

- ArticlePage is pushed with MaterialPageRoute from TimelinePage; existing back navigation can pop this route.
- ArticlePage has selectable content, a vertically scrolling ListView, and an appearance modal sheet. Back handling must respect overlays and scrolling.
- No existing custom keyboard or gesture navigation was found.
- Desktop gesture delivery must be verified before choosing a Dart-only or native implementation.

## Verified source observations
- Installed Flutter engine's macOS FlutterViewController forwards scrollWheel to dispatchGestureEvent, but swipeWithEvent is a no-op. MainFlutterWindow currently constructs a plain FlutterViewController.
- Existing test/widget_test.dart uses real in-memory Drift repositories and covers opening/saving and the visible Back button; it is a suitable fixture pattern.
- Existing desktop window code uses an injectable platform interface; reuse that architectural approach for native navigation input if needed.
- Flutter documents trackpad pan/zoom sequences and warns that event delivery depends on platform and trackpad driver: [Flutter trackpad gestures](https://docs.flutter.dev/release/breaking-changes/trackpad-gestures).
- Apple documents native swipe delivery to the view under the touch: [NSResponder swipe](https://developer.apple.com/documentation/appkit/nsresponder/swipe(with:)).
- Apple exposes a system preference for tracking swipes through scroll events: [isSwipeTrackingFromScrollEventsEnabled](https://developer.apple.com/documentation/appkit/nsevent/isswipetrackingfromscrolleventsenabled).
- Windows offers a semantic application back command; whether a particular configured gesture emits it needs hardware verification: [WM_APPCOMMAND](https://learn.microsoft.com/en-us/windows/win32/inputdev/wm-appcommand).

## Planning limits
No physical trackpad or cross-platform desktop verification was performed. Linux compositor and Windows driver mappings remain explicit investigation tasks, not confirmed support.

## Implementation findings
- Flutter's `PanGestureRecognizer` turns trackpad `PointerPanZoom` sequences into start/update/end callbacks and participates in the gesture arena, allowing a nested horizontal content recognizer to win.
- Escape is mapped to `DismissIntent`. A desktop reader action is needed because Flutter's generic page-route dismiss action is disabled for non-dismissible page routes. Keeping the shared intent also lets a focused selection action take precedence.
- The desktop gesture channels use `flood/desktop_navigation` and `backGesture`. Windows maps `WM_APPCOMMAND/APPCOMMAND_BROWSER_BACKWARD`; macOS maps positive `NSEvent.deltaX` from AppKit's `swipe(with:)`.
- Automated integration coverage currently simulates trackpad pan and the native channel event across desktop variants. Native runner compilation and physical gesture delivery remain unverified on this Linux host.
- The Linux runner compiles successfully; no layout or color behavior changed, but real-device interaction and design-guide visual cases were not manually inspected.
