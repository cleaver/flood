import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/models/article_with_state.dart';

abstract interface class ArticleRepository {
  Stream<List<ArticleWithState>> watchArticles(ArticleQuery query);

  Stream<ArticleWithState?> watchArticle(String id);

  Future<void> markRead(String id, {required bool isRead});

  Future<void> setStarred(String id, {required bool isStarred});

  Future<void> saveScrollOffset(String id, double offset);
}
