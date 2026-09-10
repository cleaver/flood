import 'package:drift/drift.dart';

import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/feed_parsing/parsed_feed.dart';
import 'package:flood/core/models/feed.dart';
import 'package:flood/core/models/feed_refresh_result.dart';
import 'package:flood/core/repositories/feed_repository.dart';
import 'package:flood/core/utils/stable_id.dart';

class DriftFeedRepository implements FeedRepository {
  DriftFeedRepository(this._database, this._source, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final FloodDatabase _database;
  final FeedSource _source;
  final DateTime Function() _now;

  @override
  Stream<List<Feed>> watchFeeds() {
    final query = _database.select(_database.feedRows)
      ..orderBy([(feed) => OrderingTerm.asc(feed.createdAt)]);
    return query.watch().map(
      (records) => records.map(_feedFromRecord).toList(growable: false),
    );
  }

  @override
  Future<Feed?> getFeed(String id) async {
    final query = _database.select(_database.feedRows)
      ..where((feed) => feed.id.equals(id));
    final record = await query.getSingleOrNull();
    return record == null ? null : _feedFromRecord(record);
  }

  @override
  Future<Feed> subscribe(Uri url) async {
    final normalizedUrl = _normalizeUrl(url);
    final existingQuery = _database.select(_database.feedRows)
      ..where((feed) => feed.url.equals(normalizedUrl.toString()));
    final existing = await existingQuery.getSingleOrNull();
    if (existing != null) {
      await refresh(existing.id);
      return (await getFeed(existing.id))!;
    }

    final loaded = await _source.load(normalizedUrl);
    if (loaded is! FeedLoaded) {
      throw StateError('A new subscription cannot be not-modified.');
    }

    final now = _now().toUtc();
    final feedId = stableId('feed', normalizedUrl.toString());
    await _database.transaction(() async {
      await _database
          .into(_database.feedRows)
          .insert(
            FeedRowsCompanion.insert(
              id: feedId,
              url: normalizedUrl.toString(),
              title: _feedTitle(loaded.feed, normalizedUrl),
              siteUrl: Value(loaded.feed.siteUrl?.toString()),
              description: Value(loaded.feed.description),
              iconUrl: Value(loaded.feed.iconUrl?.toString()),
              etag: Value(loaded.etag),
              lastModified: Value(loaded.lastModified),
              lastRefreshAttemptAt: Value(now),
              lastSuccessfulRefreshAt: Value(now),
              createdAt: now,
            ),
          );
      await _upsertArticles(feedId, loaded.feed.articles, now);
    });

    return (await getFeed(feedId))!;
  }

  @override
  Future<void> unsubscribe(String id) async {
    await (_database.delete(
      _database.feedRows,
    )..where((feed) => feed.id.equals(id))).go();
  }

  @override
  Future<FeedRefreshResult> refresh(String id) async {
    final query = _database.select(_database.feedRows)
      ..where((feed) => feed.id.equals(id));
    final existing = await query.getSingleOrNull();
    if (existing == null) {
      throw ArgumentError.value(id, 'id', 'Feed does not exist.');
    }

    final finishedAt = _now().toUtc();
    try {
      final loaded = await _source.load(
        Uri.parse(existing.url),
        etag: existing.etag,
        lastModified: existing.lastModified,
      );
      if (loaded is FeedUnchanged) {
        await _updateRefreshSuccess(
          existing,
          loaded,
          finishedAt,
          parsedFeed: null,
        );
        return FeedRefreshSuccess(
          feedId: id,
          finishedAt: finishedAt,
          newArticleCount: 0,
        );
      }

      final fresh = loaded as FeedLoaded;
      final existingIds =
          await (_database.selectOnly(_database.articleRows)
                ..addColumns([_database.articleRows.id])
                ..where(_database.articleRows.feedId.equals(id)))
              .map((row) => row.read(_database.articleRows.id)!)
              .get();
      final newCount = fresh.feed.articles
          .where(
            (article) => !existingIds.contains(stableId(id, article.sourceKey)),
          )
          .length;

      await _database.transaction(() async {
        await _updateRefreshSuccess(
          existing,
          fresh,
          finishedAt,
          parsedFeed: fresh.feed,
        );
        await _upsertArticles(id, fresh.feed.articles, finishedAt);
      });
      return FeedRefreshSuccess(
        feedId: id,
        finishedAt: finishedAt,
        newArticleCount: newCount,
      );
    } catch (error) {
      await (_database.update(
        _database.feedRows,
      )..where((feed) => feed.id.equals(id))).write(
        FeedRowsCompanion(
          lastRefreshAttemptAt: Value(finishedAt),
          refreshError: Value(error.toString()),
        ),
      );
      return FeedRefreshFailure(
        feedId: id,
        finishedAt: finishedAt,
        message: error.toString(),
      );
    }
  }

  @override
  Future<List<FeedRefreshResult>> refreshAll() async {
    final ids =
        await (_database.selectOnly(_database.feedRows)
              ..addColumns([_database.feedRows.id]))
            .map((row) => row.read(_database.feedRows.id)!)
            .get();
    final results = <FeedRefreshResult>[];
    for (final id in ids) {
      results.add(await refresh(id));
    }
    return results;
  }

  Future<void> _updateRefreshSuccess(
    FeedRecord existing,
    FeedLoadResult loaded,
    DateTime finishedAt, {
    required ParsedFeed? parsedFeed,
  }) async {
    await (_database.update(
      _database.feedRows,
    )..where((feed) => feed.id.equals(existing.id))).write(
      FeedRowsCompanion(
        title: parsedFeed == null
            ? const Value.absent()
            : Value(_feedTitle(parsedFeed, Uri.parse(existing.url))),
        siteUrl: parsedFeed == null
            ? const Value.absent()
            : Value(parsedFeed.siteUrl?.toString()),
        description: parsedFeed == null
            ? const Value.absent()
            : Value(parsedFeed.description),
        iconUrl: parsedFeed == null
            ? const Value.absent()
            : Value(parsedFeed.iconUrl?.toString()),
        etag: Value(loaded.etag),
        lastModified: Value(loaded.lastModified),
        lastRefreshAttemptAt: Value(finishedAt),
        lastSuccessfulRefreshAt: Value(finishedAt),
        refreshError: const Value(null),
      ),
    );
  }

  Future<void> _upsertArticles(
    String feedId,
    List<ParsedArticle> articles,
    DateTime fetchedAt,
  ) async {
    for (final article in articles) {
      await _database
          .into(_database.articleRows)
          .insertOnConflictUpdate(
            ArticleRowsCompanion.insert(
              id: stableId(feedId, article.sourceKey),
              feedId: feedId,
              sourceKey: article.sourceKey,
              url: Value(article.url?.toString()),
              title: article.title,
              author: Value(article.author),
              summaryHtml: Value(article.summaryHtml),
              contentHtml: Value(article.contentHtml),
              publishedAt: Value(article.publishedAt),
              updatedAt: Value(article.updatedAt),
              fetchedAt: fetchedAt,
            ),
          );
    }
  }

  Feed _feedFromRecord(FeedRecord record) => Feed(
    id: record.id,
    url: Uri.parse(record.url),
    title: record.title,
    createdAt: record.createdAt,
    siteUrl: _optionalUri(record.siteUrl),
    description: record.description,
    iconUrl: _optionalUri(record.iconUrl),
    lastRefreshAttemptAt: record.lastRefreshAttemptAt,
    lastSuccessfulRefreshAt: record.lastSuccessfulRefreshAt,
    refreshError: record.refreshError,
  );

  Uri? _optionalUri(String? value) =>
      value == null || value.isEmpty ? null : Uri.tryParse(value);

  Uri _normalizeUrl(Uri url) {
    if (!url.hasAuthority || (url.scheme != 'http' && url.scheme != 'https')) {
      throw ArgumentError.value(
        url,
        'url',
        'Feed URLs must use HTTP or HTTPS.',
      );
    }
    return url.replace(fragment: '');
  }

  String _feedTitle(ParsedFeed feed, Uri url) =>
      feed.title.trim().isEmpty ? url.host : feed.title.trim();
}
