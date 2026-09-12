import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flood/core/models/article.dart';
import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/models/article_state.dart';
import 'package:flood/core/models/article_with_state.dart';
import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/features/article/presentation/article_page.dart';

const _prose = 'A quiet place to read and think.';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('centers readable prose and overrides publisher typography', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _open(tester);

    final paragraph = _paragraph(tester, _prose);
    expect(paragraph.size.width, lessThanOrEqualTo(680));
    expect(paragraph.localToGlobal(Offset.zero).dx, greaterThanOrEqualTo(300));
    final body = _style(paragraph.text, _prose)!;
    expect(body.fontFamily, 'Source Serif 4');
    expect(body.fontSize, 19);
    expect(body.height, 1.6);
    expect(
      _style(
        _paragraph(tester, 'A slower morning').text,
        'A slower morning',
      )!.fontFamily,
      'Inter',
    );
  });

  testWidgets('switches rendered font and remembers it when reopening', (
    tester,
  ) async {
    await _open(tester);
    await tester.tap(find.byTooltip('Article appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sans serif'));
    await tester.pumpAndSettle();
    expect(
      _style(_paragraph(tester, _prose).text, _prose)!.fontFamily,
      'Inter',
    );

    await tester.pumpWidget(const SizedBox());
    await _open(tester);
    expect(
      _style(_paragraph(tester, _prose).text, _prose)!.fontFamily,
      'Inter',
    );
    await tester.tap(find.byTooltip('Article appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editorial'));
    await tester.pumpAndSettle();
    expect(
      _style(_paragraph(tester, _prose).text, _prose)!.fontFamily,
      'Source Serif 4',
    );
  });

  testWidgets('white appearance recolors rendered content in a dark app', (
    tester,
  ) async {
    await _open(tester, dark: true);
    final dark = _style(_paragraph(tester, _prose).text, _prose)!.color!;
    await tester.tap(find.byTooltip('Article appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('White article'));
    await tester.pumpAndSettle();
    final light = _style(_paragraph(tester, _prose).text, _prose)!.color!;
    expect(light.computeLuminance(), lessThan(dark.computeLuminance()));
    expect(light.computeLuminance(), lessThan(.1));
    expect(
      _style(_paragraph(tester, 'A link').text, 'A link')!.color,
      isNot(const Color(0xFFFFFF00)),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('restores and saves the article scroll position', (tester) async {
    final articles = _Articles(initialScrollOffset: 120, longContent: true);
    await tester.pumpWidget(
      MaterialApp(
        home: ArticlePage(articleId: 'one', repository: articles),
      ),
    );
    await tester.pumpAndSettle();

    final list = tester.widget<ListView>(
      find.byKey(const PageStorageKey('reader-one')),
    );
    expect(list.controller!.offset, 120);

    list.controller!.jumpTo(220);
    await tester.pump(const Duration(milliseconds: 350));
    expect(articles.savedOffsets, contains(220));
  });

  testWidgets('keeps long titles and missing content usable at 640 by 480', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(640, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: ArticlePage(
          articleId: 'one',
          repository: _Articles(longTitle: true, emptyContent: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('A very long article title'), findsOneWidget);
    expect(
      find.text('This feed did not include article content.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports enlarged text without making content unreachable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: ArticlePage(
          articleId: 'one',
          repository: _Articles(longTitle: true, emptyContent: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('This feed did not include article content.'),
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(
      find.text('This feed did not include article content.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(WidgetTester tester, {bool dark = false}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: ArticlePage(articleId: 'one', repository: _Articles()),
    ),
  );
  await tester.pumpAndSettle();
}

RenderParagraph _paragraph(WidgetTester tester, String text) => tester
    .renderObjectList<RenderParagraph>(find.byType(RichText))
    .firstWhere((paragraph) => paragraph.text.toPlainText().contains(text));

TextStyle? _style(InlineSpan span, String text, [TextStyle? inherited]) {
  final effective = inherited?.merge(span.style) ?? span.style;
  if (span is TextSpan) {
    if (span.text?.contains(text) ?? false) return effective;
    for (final child in span.children ?? <InlineSpan>[]) {
      final result = _style(child, text, effective);
      if (result != null) return result;
    }
  }
  return null;
}

class _Articles implements ArticleRepository {
  _Articles({
    this.initialScrollOffset = 0,
    this.longContent = false,
    this.longTitle = false,
    this.emptyContent = false,
  });

  final double initialScrollOffset;
  final bool longContent;
  final bool longTitle;
  final bool emptyContent;
  final savedOffsets = <double>[];

  @override
  Stream<ArticleWithState?> watchArticle(String id) => Stream.value(
    ArticleWithState(
      article: Article(
        id: id,
        feedId: 'feed',
        sourceKey: id,
        title: longTitle
            ? 'A very long article title that should wrap gently across several lines without clipping'
            : 'A slower morning',
        author: 'River Writer',
        fetchedAt: DateTime(2026),
        contentHtml: emptyContent
            ? null
            : longContent
            ? List.filled(40, '<p>$_prose</p>').join()
            : '''
<div style="width: 1800px; background-color: red; color: yellow; font-family: Courier; font-size: 10px">
<p style="font-size: 10px; line-height: 1; text-align: justify">$_prose</p>
<p><a href="https://example.com" style="color: yellow">A link</a></p>
</div>''',
      ),
      state: ArticleState(articleId: id, scrollOffset: initialScrollOffset),
      feedTitle: 'Flood Journal',
    ),
  );

  @override
  Stream<List<ArticleWithState>> watchArticles(ArticleQuery query) =>
      Stream.value([]);
  @override
  Future<void> markRead(String id, {required bool isRead}) async {}
  @override
  Future<void> setStarred(String id, {required bool isStarred}) async {}
  @override
  Future<void> saveScrollOffset(String id, double offset) async {
    savedOffsets.add(offset);
  }
}
