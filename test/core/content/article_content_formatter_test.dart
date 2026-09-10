import 'package:flutter_test/flutter_test.dart';

import 'package:flood/core/content/article_content_formatter.dart';

void main() {
  const formatter = ArticleContentFormatter();

  test('formats Markdown structure as HTML', () {
    const source = '''
## A heading

This has *emphasis* and [a link](https://example.com).

> A quoted line
''';

    final formatted = formatter.format(source);

    expect(formatted, contains('<h2>A heading</h2>'));
    expect(formatted, contains('<em>emphasis</em>'));
    expect(formatted, contains('<a href="https://example.com">a link</a>'));
    expect(formatted, contains('<blockquote>'));
  });

  test('leaves rich HTML unchanged even with Markdown-looking text', () {
    const source = '''
<p><strong>Tool:</strong> <a href="https://example.com">Viewer</a></p>
<blockquote><p>Already rich: [not a link](keep).</p></blockquote>
<p><img src="https://example.com/image.webp" /></p>
<center><video controls></video></center>
''';

    expect(formatter.format(source), source);
  });

  test('formats Markdown that contains a simple inline HTML link', () {
    const source = '_Photo by <a href="https://example.com">River</a>_';

    final formatted = formatter.format(source);

    expect(
      formatted,
      contains('<em>Photo by <a href="https://example.com">River</a></em>'),
    );
  });

  test('leaves plain prose and inline HTML without Markdown unchanged', () {
    const prose = 'A sentence without any formatting markers.';
    const html = '<a href="https://example.com">Read more</a>';

    expect(formatter.format(prose), prose);
    expect(formatter.format(html), html);
  });
}
