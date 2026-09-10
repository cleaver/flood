import 'package:drift/drift.dart';

import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/models/article.dart';
import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/models/article_state.dart';
import 'package:flood/core/models/article_with_state.dart';
import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/core/utils/article_deduplication_key.dart';

class DriftArticleRepository implements ArticleRepository {
  DriftArticleRepository(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final FloodDatabase _database;
  final DateTime Function() _now;

  @override
  Stream<List<ArticleWithState>> watchArticles(ArticleQuery filter) {
    final query = _baseQuery();
    if (filter.feedId != null) {
      query.where(_database.articleRows.feedId.equals(filter.feedId!));
    }
    switch (filter.scope) {
      case ArticleScope.all:
        break;
      case ArticleScope.unread:
        query.where(_database.articleStateRows.readAt.isNull());
      case ArticleScope.starred:
        query.where(_database.articleStateRows.isStarred.equals(true));
    }

    return query.watch().map((rows) {
      final articles = rows.map(_articleFromRow).toList()
        ..sort(
          (left, right) =>
              right.article.sortDate.compareTo(left.article.sortDate),
        );
      return _deduplicate(articles).take(filter.limit).toList(growable: false);
    });
  }

  @override
  Stream<ArticleWithState?> watchArticle(String id) {
    final query = _baseQuery()..where(_database.articleRows.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _articleFromRow(row),
    );
  }

  @override
  Future<void> markRead(String id, {required bool isRead}) async {
    final readAt = isRead ? _now().toUtc() : null;
    await _database.transaction(() async {
      for (final matchingId in await _matchingArticleIds(id)) {
        await _ensureState(matchingId);
        await (_database.update(_database.articleStateRows)
              ..where((state) => state.articleId.equals(matchingId)))
            .write(ArticleStateRowsCompanion(readAt: Value(readAt)));
      }
    });
  }

  @override
  Future<void> setStarred(String id, {required bool isStarred}) async {
    await _database.transaction(() async {
      for (final matchingId in await _matchingArticleIds(id)) {
        await _ensureState(matchingId);
        await (_database.update(_database.articleStateRows)
              ..where((state) => state.articleId.equals(matchingId)))
            .write(ArticleStateRowsCompanion(isStarred: Value(isStarred)));
      }
    });
  }

  @override
  Future<void> saveScrollOffset(String id, double offset) async {
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Must not be negative.');
    }
    await _ensureState(id);
    await (_database.update(_database.articleStateRows)
          ..where((state) => state.articleId.equals(id)))
        .write(ArticleStateRowsCompanion(scrollOffset: Value(offset)));
  }

  JoinedSelectStatement<HasResultSet, dynamic> _baseQuery() {
    return _database.select(_database.articleRows).join([
      innerJoin(
        _database.feedRows,
        _database.feedRows.id.equalsExp(_database.articleRows.feedId),
      ),
      leftOuterJoin(
        _database.articleStateRows,
        _database.articleStateRows.articleId.equalsExp(
          _database.articleRows.id,
        ),
      ),
    ]);
  }

  ArticleWithState _articleFromRow(TypedResult row) {
    final article = row.readTable(_database.articleRows);
    final state = row.readTableOrNull(_database.articleStateRows);
    final feed = row.readTable(_database.feedRows);
    return ArticleWithState(
      feedTitle: feed.title,
      article: Article(
        id: article.id,
        feedId: article.feedId,
        sourceKey: article.sourceKey,
        title: article.title,
        fetchedAt: article.fetchedAt,
        url: _optionalUri(article.url),
        author: article.author,
        summaryHtml: article.summaryHtml,
        contentHtml: article.contentHtml,
        publishedAt: article.publishedAt,
        updatedAt: article.updatedAt,
      ),
      state: ArticleState(
        articleId: article.id,
        readAt: state?.readAt,
        isStarred: state?.isStarred ?? false,
        scrollOffset: state?.scrollOffset ?? 0,
      ),
    );
  }

  Uri? _optionalUri(String? value) =>
      value == null || value.isEmpty ? null : Uri.tryParse(value);

  List<ArticleWithState> _deduplicate(List<ArticleWithState> articles) {
    final unique = <String, ArticleWithState>{};
    for (final candidate in articles) {
      final key = articleDeduplicationKey(candidate.article);
      final current = unique[key];
      if (current == null || _isPreferred(candidate, current)) {
        unique[key] = candidate;
      }
    }
    final deduplicated = unique.values.toList()
      ..sort(
        (left, right) =>
            right.article.sortDate.compareTo(left.article.sortDate),
      );
    return deduplicated;
  }

  bool _isPreferred(ArticleWithState candidate, ArticleWithState current) {
    final candidateScore =
        (candidate.state.isRead ? 0 : 2) + (candidate.state.isStarred ? 1 : 0);
    final currentScore =
        (current.state.isRead ? 0 : 2) + (current.state.isStarred ? 1 : 0);
    if (candidateScore != currentScore) return candidateScore > currentScore;
    return candidate.article.sortDate.isAfter(current.article.sortDate);
  }

  Future<List<String>> _matchingArticleIds(String id) async {
    final target = await (_database.select(
      _database.articleRows,
    )..where((article) => article.id.equals(id))).getSingle();
    final key = articleDeduplicationKeyForValues(
      id: target.id,
      url: _optionalUri(target.url),
    );
    final allArticles = await _database.select(_database.articleRows).get();
    return allArticles
        .where(
          (article) =>
              articleDeduplicationKeyForValues(
                id: article.id,
                url: _optionalUri(article.url),
              ) ==
              key,
        )
        .map((article) => article.id)
        .toList(growable: false);
  }

  Future<void> _ensureState(String id) async {
    await _database
        .into(_database.articleStateRows)
        .insert(
          ArticleStateRowsCompanion.insert(articleId: id),
          mode: InsertMode.insertOrIgnore,
        );
  }
}
