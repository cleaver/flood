import 'package:markdown/markdown.dart' as markdown;

/// Chooses a safe representation for feed-supplied article content.
///
/// Feed fields are named `*Html` for historical reasons, but some publishers
/// put Markdown in those fields. Markdown is converted to HTML only when the
/// content has recognizable Markdown structure and does not contain block HTML
/// that should be handed to the existing HTML renderer unchanged.
class ArticleContentFormatter {
  const ArticleContentFormatter();

  static final _blockHtmlTagPattern = RegExp(
    r'''<\s*/?\s*(?:address|article|aside|audio|blockquote|body|canvas|caption|center|col|colgroup|dd|details|dialog|div|dl|dt|fieldset|figcaption|figure|footer|form|h[1-6]|head|header|hgroup|hr|html|li|main|menu|nav|ol|p|pre|script|section|summary|table|tbody|td|tfoot|th|thead|title|tr|track|ul|video)\b[^<>]*>''',
    caseSensitive: false,
  );

  static final _htmlTagPattern = RegExp(
    r'''<\s*/?\s*[A-Za-z][A-Za-z0-9:-]*(?:\s+[^<>]*?)?\s*/?\s*>''',
    caseSensitive: false,
  );

  static final _htmlCommentPattern = RegExp(
    r'''<!--[^]*?-->|<\?[^>]*\?>|<![A-Za-z][^>]*>''',
    caseSensitive: false,
  );

  static final _markdownSignals = <RegExp>[
    RegExp(r'^\s{0,3}#{1,6}\s+\S', multiLine: true),
    RegExp(r'^\s{0,3}(?:`{3,}|~{3,})', multiLine: true),
    RegExp(r'^\s{0,3}>\s+\S', multiLine: true),
    RegExp(r'^\s{0,3}(?:[-+*]|\d+[.)])\s+\S', multiLine: true),
    RegExp(
      r'^\s*\|?.+\|.+\n\s*\|?\s*:?-+:?\s*(?:\|\s*:?-+:?\s*)+\|?\s*$',
      multiLine: true,
    ),
    RegExp(r'!?\[[^\]\n]+\]\([^\)\n]+\)'),
    RegExp(r'(?<!\w)\*\*(?=\S)[^*\n]*?\S\*\*(?!\w)'),
    RegExp(r'(?<!\w)__(?=\S)[^_\n]*?\S__(?!\w)'),
    RegExp(r'(?<!\w)\*(?=\S)[^*\n]*?\S\*(?!\w)'),
    RegExp(r'(?<!\w)_(?=\S)[^_\n]*?\S_(?!\w)'),
    RegExp(r'(?<!\w)~~(?=\S)[^~\n]*?\S~~(?!\w)'),
    RegExp(r'`[^`\n]+`'),
    RegExp(r'\[\^[^\]\n]+\]'),
    RegExp(r'^\s*\S[^\n]*\n\s*(?:=+|-+)\s*$', multiLine: true),
  ];

  /// Returns HTML suitable for the existing HTML widget, or the original value
  /// when it is already HTML/plain text or has no convincing Markdown structure.
  String? format(String? content) {
    if (content == null) return null;
    final trimmed = content.trim();
    if (trimmed.isEmpty || !_looksLikeMarkdown(trimmed)) return content;

    try {
      return markdown.markdownToHtml(
        trimmed,
        extensionSet: markdown.ExtensionSet.gitHubFlavored,
        encodeHtml: true,
        enableTagfilter: true,
      );
    } on Object {
      // A malformed Markdown document should never prevent an article from
      // opening; the original feed payload is the safest fallback.
      return content;
    }
  }

  bool _looksLikeMarkdown(String content) {
    if (_blockHtmlTagPattern.hasMatch(content)) return false;

    final withoutInlineHtml = content
        .replaceAll(_htmlTagPattern, '')
        .replaceAll(_htmlCommentPattern, '');
    return _markdownSignals.any((signal) => signal.hasMatch(withoutInlineHtml));
  }
}
