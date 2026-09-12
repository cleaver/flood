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
