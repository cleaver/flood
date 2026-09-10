import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/feed_parsing/parsed_feed.dart';
import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/models/feed_refresh_result.dart';
import 'package:flood/core/repositories/drift_article_repository.dart';
import 'package:flood/core/repositories/drift_feed_repository.dart';

void main() {
  late FloodDatabase database;
  late FakeFeedSource source;
  late DriftFeedRepository feeds;
  late DriftArticleRepository articles;
  final now = DateTime.utc(2026, 9, 9, 12);

  setUp(() {
    database = FloodDatabase(NativeDatabase.memory());
    source = FakeFeedSource();
    feeds = DriftFeedRepository(database, source, now: () => now);
    articles = DriftArticleRepository(database, now: () => now);
  });

  tearDown(() => database.close());

  test(
    'subscribe fetches and atomically persists a feed and its articles',
    () async {
      source.results.add(_loaded(title: 'Flood Journal', etag: '"v1"'));

      final feed = await feeds.subscribe(
        Uri.parse('https://example.com/feed.xml'),
      );
      final persistedFeeds = await feeds.watchFeeds().first;
      final timeline = await articles.watchArticles(const ArticleQuery()).first;

      expect(feed.title, 'Flood Journal');
      expect(persistedFeeds.single.id, feed.id);
      expect(timeline.single.article.title, 'First article');
      expect(timeline.single.feedTitle, 'Flood Journal');
      expect(timeline.single.state.isRead, isFalse);
    },
  );

  test('refresh sends validators and preserves reader state', () async {
    source.results
      ..add(_loaded(title: 'Flood Journal', etag: '"v1"'))
      ..add(
        _loaded(title: 'Renamed Journal', etag: '"v2"', content: 'Updated'),
      );
    final feed = await feeds.subscribe(
      Uri.parse('https://example.com/feed.xml'),
    );
    final initial = await articles.watchArticles(const ArticleQuery()).first;
    final articleId = initial.single.article.id;
    await articles.markRead(articleId, isRead: true);
    await articles.setStarred(articleId, isStarred: true);

    final result = await feeds.refresh(feed.id);
    final refreshedFeed = await feeds.getFeed(feed.id);
    final refreshedArticle = await articles.watchArticle(articleId).first;

    expect(result, isA<FeedRefreshSuccess>());
    expect((result as FeedRefreshSuccess).newArticleCount, 0);
    expect(source.requests.last.etag, '"v1"');
    expect(refreshedFeed!.title, 'Renamed Journal');
    expect(refreshedArticle!.article.contentHtml, 'Updated');
    expect(refreshedArticle.state.isRead, isTrue);
    expect(refreshedArticle.state.isStarred, isTrue);
  });

  test(
    'an unchanged refresh updates successfully without replacing articles',
    () async {
      source.results
        ..add(_loaded(title: 'Flood Journal', etag: '"v1"'))
        ..add(
          const FeedUnchanged(etag: '"v1"', lastModified: 'Wed, 09 Sep 2026'),
        );
      final feed = await feeds.subscribe(
        Uri.parse('https://example.com/feed.xml'),
      );

      final result = await feeds.refresh(feed.id);
      final timeline = await articles.watchArticles(const ArticleQuery()).first;

      expect(result, isA<FeedRefreshSuccess>());
      expect(timeline, hasLength(1));
    },
  );

  test('article filters react to read and starred state', () async {
    source.results.add(_loaded(title: 'Flood Journal', etag: '"v1"'));
    await feeds.subscribe(Uri.parse('https://example.com/feed.xml'));
    final article =
        (await articles.watchArticles(const ArticleQuery()).first).single;

    await articles.markRead(article.article.id, isRead: true);
    await articles.setStarred(article.article.id, isStarred: true);

    final unread = await articles
        .watchArticles(const ArticleQuery(scope: ArticleScope.unread))
        .first;
    final starred = await articles
        .watchArticles(const ArticleQuery(scope: ArticleScope.starred))
        .first;
    expect(unread, isEmpty);
    expect(starred.single.article.id, article.article.id);
  });
}

FeedLoaded _loaded({
  required String title,
  required String etag,
  String content = '<p>Readable content.</p>',
}) {
  return FeedLoaded(
    etag: etag,
    lastModified: 'Wed, 09 Sep 2026 12:00:00 GMT',
    feed: ParsedFeed(
      title: title,
      description: 'A test feed',
      siteUrl: Uri.parse('https://example.com/'),
      articles: [
        ParsedArticle(
          sourceKey: 'article-1',
          title: 'First article',
          url: Uri.parse('https://example.com/articles/one'),
          author: 'River Writer',
          contentHtml: content,
          publishedAt: DateTime.utc(2026, 9, 8, 10),
        ),
      ],
    ),
  );
}

class FeedRequest {
  const FeedRequest({required this.uri, this.etag, this.lastModified});

  final Uri uri;
  final String? etag;
  final String? lastModified;
}

class FakeFeedSource implements FeedSource {
  final results = <FeedLoadResult>[];
  final requests = <FeedRequest>[];

  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    requests.add(FeedRequest(uri: uri, etag: etag, lastModified: lastModified));
    return results.removeAt(0);
  }
}
