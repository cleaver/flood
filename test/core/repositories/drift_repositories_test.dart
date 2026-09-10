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
    'forced refresh bypasses stale validators and reconciles removals',
    () async {
      source.results
        ..add(_loaded(title: 'Flood Journal', etag: '"v1"'))
        ..add(_loaded(title: 'Flood Journal', etag: '"v1"', articles: []));
      final feed = await feeds.subscribe(
        Uri.parse('https://example.com/feed.xml'),
      );
      final articleId =
          (await articles.watchArticles(const ArticleQuery()).first)
              .single
              .article
              .id;

      final result = await feeds.refresh(feed.id, force: true);
      final removed = await articles.watchArticle(articleId).first;

      expect(result, isA<FeedRefreshSuccess>());
      expect(source.requests.last.etag, isNull);
      expect(source.requests.last.lastModified, isNull);
      expect(removed!.article.isRemoved, isTrue);
    },
  );

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

  test(
    'deduplicates matching article URLs across feeds and syncs their state',
    () async {
      source.results
        ..add(
          _loaded(
            title: 'Primary Feed',
            etag: '"v1"',
            sourceKey: 'primary-guid',
          ),
        )
        ..add(
          _loaded(title: 'Mirror Feed', etag: '"v1"', sourceKey: 'mirror-guid'),
        );

      final first = await feeds.subscribe(
        Uri.parse('https://one.example/feed'),
      );
      final second = await feeds.subscribe(
        Uri.parse('https://two.example/feed'),
      );
      final timeline = await articles.watchArticles(const ArticleQuery()).first;

      expect(timeline, hasLength(1));
      final shownArticle = timeline.single.article;
      await articles.setStarred(shownArticle.id, isStarred: true);
      await articles.markRead(shownArticle.id, isRead: true);

      final firstFeed = await articles
          .watchArticles(ArticleQuery(feedId: first.id))
          .first;
      final secondFeed = await articles
          .watchArticles(ArticleQuery(feedId: second.id))
          .first;
      final unread = await articles
          .watchArticles(const ArticleQuery(scope: ArticleScope.unread))
          .first;
      final saved = await articles
          .watchArticles(const ArticleQuery(scope: ArticleScope.starred))
          .first;

      expect(firstFeed.single.state.isRead, isTrue);
      expect(secondFeed.single.state.isRead, isTrue);
      expect(firstFeed.single.state.isStarred, isTrue);
      expect(secondFeed.single.state.isStarred, isTrue);
      expect(unread, isEmpty);
      expect(saved, hasLength(1));
    },
  );

  test(
    'retries a failed refresh and removes a feed with its articles',
    () async {
      source.results.add(_loaded(title: 'Flood Journal', etag: '"v1"'));
      final feed = await feeds.subscribe(Uri.parse('https://example.com/feed'));

      source.errors.add(StateError('offline'));
      final failed = await feeds.refresh(feed.id);
      expect(failed, isA<FeedRefreshFailure>());
      expect((await feeds.getFeed(feed.id))!.refreshError, contains('offline'));

      source.results.add(_loaded(title: 'Flood Journal', etag: '"v2"'));
      final retried = await feeds.refresh(feed.id);
      expect(retried, isA<FeedRefreshSuccess>());
      expect((await feeds.getFeed(feed.id))!.refreshError, isNull);

      await feeds.unsubscribe(feed.id);
      expect(await feeds.watchFeeds().first, isEmpty);
      expect(await articles.watchArticles(const ArticleQuery()).first, isEmpty);
    },
  );

  test('updates a feed URL only after its replacement can be loaded', () async {
    source.results.add(_loaded(title: 'Old Feed', etag: '"v1"'));
    final feed = await feeds.subscribe(Uri.parse('https://example.com/old'));

    source.errors.add(StateError('bad replacement'));
    await expectLater(
      feeds.updateUrl(feed.id, Uri.parse('https://example.com/bad')),
      throwsA(isA<StateError>()),
    );
    expect(
      (await feeds.getFeed(feed.id))!.url.toString(),
      'https://example.com/old',
    );

    source.results.add(_loaded(title: 'Corrected Feed', etag: '"v2"'));
    final corrected = await feeds.updateUrl(
      feed.id,
      Uri.parse('https://example.com/corrected'),
    );

    expect(corrected.url.toString(), 'https://example.com/corrected');
    expect(corrected.title, 'Corrected Feed');
  });

  test(
    'reconciles duplicate GUIDs as one latest article during refresh',
    () async {
      source.results
        ..add(_loaded(title: 'Revisions', etag: '"v1"', articles: []))
        ..add(
          _loaded(
            title: 'Revisions',
            etag: '"v2"',
            articles: [
              ParsedArticle(
                sourceKey: 'revised-guid',
                title: 'First revision',
                contentHtml: '<p>Old</p>',
              ),
              ParsedArticle(
                sourceKey: 'revised-guid',
                title: 'Latest revision',
                contentHtml: '<p>New</p>',
              ),
            ],
          ),
        );
      final feed = await feeds.subscribe(Uri.parse('https://example.com/feed'));

      final refresh = await feeds.refresh(feed.id);
      final timeline = await articles.watchArticles(const ArticleQuery()).first;

      expect((refresh as FeedRefreshSuccess).newArticleCount, 1);
      expect(timeline, hasLength(1));
      expect(timeline.single.article.title, 'Latest revision');
      expect(timeline.single.article.contentHtml, '<p>New</p>');
    },
  );

  test(
    'marks missing entries removed, then clears it when they return',
    () async {
      source.results
        ..add(_loaded(title: 'Journal', etag: '"v1"'))
        ..add(_loaded(title: 'Journal', etag: '"v2"', articles: []))
        ..add(_loaded(title: 'Journal', etag: '"v3"', content: 'Returned'));
      final feed = await feeds.subscribe(Uri.parse('https://example.com/feed'));
      final initial =
          (await articles.watchArticles(const ArticleQuery()).first).single;
      await articles.markRead(initial.article.id, isRead: true);
      await articles.setStarred(initial.article.id, isStarred: true);
      await articles.saveScrollOffset(initial.article.id, 42);

      final removedRefresh = await feeds.refresh(feed.id);
      final removed = await articles.watchArticle(initial.article.id).first;

      expect(removedRefresh, isA<FeedRefreshSuccess>());
      expect(removed!.article.isRemoved, isTrue);
      expect(removed.state.isRead, isTrue);
      expect(removed.state.isStarred, isTrue);
      expect(removed.state.scrollOffset, 42);

      final returnedRefresh = await feeds.refresh(feed.id);
      final returned = await articles.watchArticle(initial.article.id).first;

      expect(returnedRefresh, isA<FeedRefreshSuccess>());
      expect(returned!.article.isRemoved, isFalse);
      expect(returned.article.contentHtml, 'Returned');
      expect(returned.state.isRead, isTrue);
      expect(returned.state.isStarred, isTrue);
      expect(returned.state.scrollOffset, 42);
    },
  );

  test(
    'does not mark entries removed after a failed or unchanged refresh',
    () async {
      source.results
        ..add(_loaded(title: 'Journal', etag: '"v1"'))
        ..add(const FeedUnchanged(etag: '"v1"', lastModified: 'today'));
      final feed = await feeds.subscribe(Uri.parse('https://example.com/feed'));
      final articleId =
          (await articles.watchArticles(const ArticleQuery()).first)
              .single
              .article
              .id;

      source.errors.add(StateError('offline'));
      expect(await feeds.refresh(feed.id), isA<FeedRefreshFailure>());
      expect(
        (await articles.watchArticle(articleId).first)!.article.isRemoved,
        isFalse,
      );

      expect(await feeds.refresh(feed.id), isA<FeedRefreshSuccess>());
      expect(
        (await articles.watchArticle(articleId).first)!.article.isRemoved,
        isFalse,
      );
    },
  );
}

FeedLoaded _loaded({
  required String title,
  required String etag,
  String content = '<p>Readable content.</p>',
  String sourceKey = 'article-1',
  List<ParsedArticle>? articles,
}) {
  return FeedLoaded(
    etag: etag,
    lastModified: 'Wed, 09 Sep 2026 12:00:00 GMT',
    feed: ParsedFeed(
      title: title,
      description: 'A test feed',
      siteUrl: Uri.parse('https://example.com/'),
      articles:
          articles ??
          [
            ParsedArticle(
              sourceKey: sourceKey,
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
  final errors = <Object>[];
  final requests = <FeedRequest>[];

  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    requests.add(FeedRequest(uri: uri, etag: etag, lastModified: lastModified));
    if (errors.isNotEmpty) throw errors.removeAt(0);
    return results.removeAt(0);
  }
}
