import 'package:html/parser.dart' as html;

/// Removes publisher presentation from a display-only copy of feed content.
/// Semantic elements, links, image sources, language, and text remain intact.
class ReaderHtmlNormalizer {
  const ReaderHtmlNormalizer();

  String normalize(String content) {
    final fragment = html.parseFragment(content);
    for (final element in fragment.querySelectorAll('*')) {
      if (const {
        'script',
        'style',
        'link',
        'meta',
      }.contains(element.localName)) {
        element.remove();
        continue;
      }
      for (final attribute in const [
        'style',
        'class',
        'width',
        'height',
        'align',
        'valign',
        'bgcolor',
        'color',
        'face',
        'size',
        'border',
        'cellpadding',
        'cellspacing',
      ]) {
        element.attributes.remove(attribute);
      }
    }
    return fragment.outerHtml;
  }
}
