class ArticleState {
  const ArticleState({
    required this.articleId,
    this.readAt,
    this.isStarred = false,
    this.scrollOffset = 0,
  });

  final String articleId;
  final DateTime? readAt;
  final bool isStarred;
  final double scrollOffset;

  bool get isRead => readAt != null;
}
