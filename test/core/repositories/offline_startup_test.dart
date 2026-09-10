import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/feed_parsing/parsed_feed.dart';
import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/repositories/drift_article_repository.dart';
import 'package:flood/core/repositories/drift_feed_repository.dart';

void main() {
  test(
    'starts offline from persisted articles without loading a feed',
    () async {
      final directory = await Directory.systemTemp.createTemp('flood_offline_');
      addTearDown(() => directory.delete(recursive: true));
      final databaseFile = File('${directory.path}/flood.sqlite');

      final onlineDatabase = FloodDatabase(NativeDatabase(databaseFile));
      final onlineSource = _LoadedSource();
      final onlineFeeds = DriftFeedRepository(onlineDatabase, onlineSource);
      await onlineFeeds.subscribe(Uri.parse('https://example.com/feed.xml'));
      await onlineDatabase.close();

      final offlineDatabase = FloodDatabase(NativeDatabase(databaseFile));
      final offlineSource = _OfflineSource();
      final offlineFeeds = DriftFeedRepository(offlineDatabase, offlineSource);
      final offlineArticles = DriftArticleRepository(offlineDatabase);

      final savedFeeds = await offlineFeeds.watchFeeds().first;
      final timeline = await offlineArticles
          .watchArticles(const ArticleQuery())
          .first;

      expect(savedFeeds.single.title, 'Offline Journal');
      expect(timeline.single.article.title, 'Saved for offline');
      expect(offlineSource.calls, 0);

      await offlineDatabase.close();
    },
  );
}

class _LoadedSource implements FeedSource {
  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    return FeedLoaded(
      etag: '"offline-v1"',
      lastModified: null,
      feed: ParsedFeed(
        title: 'Offline Journal',
        articles: [
          ParsedArticle(
            sourceKey: 'saved-article',
            title: 'Saved for offline',
            url: Uri.parse('https://example.com/articles/saved'),
          ),
        ],
      ),
    );
  }
}

class _OfflineSource implements FeedSource {
  int calls = 0;

  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    calls++;
    throw StateError('Network is unavailable.');
  }
}
