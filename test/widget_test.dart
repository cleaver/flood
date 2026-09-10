import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:flood/app.dart';
import 'package:flood/app_dependencies.dart';
import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/feed_parsing/parsed_feed.dart';
import 'package:flood/core/repositories/drift_article_repository.dart';
import 'package:flood/core/repositories/drift_feed_repository.dart';

void main() {
  testWidgets('subscribes, displays, opens, and saves an article', (
    tester,
  ) async {
    final database = FloodDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    final feeds = DriftFeedRepository(database, _FixtureSource());
    final articles = DriftArticleRepository(database);
    final dependencies = AppDependencies(
      feedRepository: feeds,
      articleRepository: articles,
    );

    await tester.pumpWidget(FloodApp(dependencies: dependencies));
    await tester.pumpAndSettle();
    expect(find.text('No articles here yet.'), findsOneWidget);

    await tester.tap(find.text('Subscriptions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add a feed'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('feed-url-field')),
      'https://example.com/feed.xml',
    );
    await tester.tap(find.text('Subscribe'));
    await tester.pumpAndSettle();

    expect(find.text('First article'), findsOneWidget);
    await tester.tap(find.text('First article'));
    await tester.pumpAndSettle();

    expect(find.text('River Writer · Flood Journal'), findsOneWidget);
    final reader = tester.widget<HtmlWidget>(find.byType(HtmlWidget));
    expect(reader.html, contains('Readable content.'));
    await tester.tap(find.byTooltip('Save article'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final stored = await database.select(database.articleStateRows).getSingle();
    expect(stored.readAt, isNotNull);
    expect(stored.isStarred, isTrue);
    await database.close();
  });
}

class _FixtureSource implements FeedSource {
  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    return FeedLoaded(
      etag: '"fixture-v1"',
      lastModified: 'Wed, 09 Sep 2026 12:00:00 GMT',
      feed: ParsedFeed(
        title: 'Flood Journal',
        siteUrl: Uri.parse('https://example.com/'),
        articles: [
          ParsedArticle(
            sourceKey: 'article-1',
            title: 'First article',
            author: 'River Writer',
            url: Uri.parse('https://example.com/articles/one'),
            contentHtml: '<p>Readable content.</p>',
            publishedAt: DateTime.utc(2026, 9, 8, 10),
          ),
        ],
      ),
    );
  }
}
