sealed class FeedRefreshResult {
  const FeedRefreshResult({required this.feedId, required this.finishedAt});

  final String feedId;
  final DateTime finishedAt;
}

final class FeedRefreshSuccess extends FeedRefreshResult {
  const FeedRefreshSuccess({
    required super.feedId,
    required super.finishedAt,
    required this.newArticleCount,
  });

  final int newArticleCount;
}

final class FeedRefreshFailure extends FeedRefreshResult {
  const FeedRefreshFailure({
    required super.feedId,
    required super.finishedAt,
    required this.message,
  });

  final String message;
}
