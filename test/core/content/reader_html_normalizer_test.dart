import 'package:flutter_test/flutter_test.dart';

import 'package:flood/core/content/reader_html_normalizer.dart';

void main() {
  test('keeps semantic content and links while removing publisher styling', () {
    const input = '''
<article class="publisher" style="color: yellow; width: 1800px">
  <style>article { color: yellow; }</style>
  <script>alert('ignored')</script>
  <h2 style="font-family: Courier">A heading</h2>
  <p><a href="https://example.com" style="color: yellow">A link</a></p>
  <img src="https://example.com/image.png" width="2400" height="900">
</article>''';

    final output = const ReaderHtmlNormalizer().normalize(input);

    expect(output, contains('<article>'));
    expect(output, contains('<h2>A heading</h2>'));
    expect(output, contains('href="https://example.com"'));
    expect(output, contains('src="https://example.com/image.png"'));
    expect(output, isNot(contains('style=')));
    expect(output, isNot(contains('class=')));
    expect(output, isNot(contains('<script')));
    expect(output, isNot(contains('<style')));
  });
}
