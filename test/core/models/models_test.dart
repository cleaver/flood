import 'package:flutter_test/flutter_test.dart';

import 'package:flood/core/models/article.dart';
import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/models/article_state.dart';

void main() {
  group('Article', () {
    test('sorts by publication, update, then fetch time', () {
      final fetchedAt = DateTime.utc(2026, 1, 1);
      final updatedAt = DateTime.utc(2026, 1, 2);
      final publishedAt = DateTime.utc(2026, 1, 3);

      Article article({DateTime? published, DateTime? updated}) => Article(
        id: 'article-1',
        feedId: 'feed-1',
        sourceKey: 'source-1',
        title: 'An article',
        fetchedAt: fetchedAt,
        publishedAt: published,
        updatedAt: updated,
      );

      expect(
        article(published: publishedAt, updated: updatedAt).sortDate,
        publishedAt,
      );
      expect(article(updated: updatedAt).sortDate, updatedAt);
      expect(article().sortDate, fetchedAt);
    });
  });

  group('ArticleState', () {
    test('is unread by default', () {
      const state = ArticleState(articleId: 'article-1');

      expect(state.isRead, isFalse);
      expect(state.isStarred, isFalse);
      expect(state.scrollOffset, 0);
    });

    test('is read when readAt is present', () {
      final state = ArticleState(
        articleId: 'article-1',
        readAt: DateTime.utc(2026, 1, 1),
      );

      expect(state.isRead, isTrue);
    });
  });

  test('ArticleQuery defaults to the unified timeline', () {
    const query = ArticleQuery();

    expect(query.scope, ArticleScope.all);
    expect(query.feedId, isNull);
    expect(query.limit, 100);
  });
}
