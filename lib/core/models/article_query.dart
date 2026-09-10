enum ArticleScope { all, unread, starred }

class ArticleQuery {
  const ArticleQuery({
    this.scope = ArticleScope.all,
    this.feedId,
    this.limit = 100,
  }) : assert(limit > 0);

  final ArticleScope scope;
  final String? feedId;
  final int limit;
}
