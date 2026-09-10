import 'package:flood/core/models/feed.dart';
import 'package:flood/core/models/feed_refresh_result.dart';

abstract interface class FeedRepository {
  Stream<List<Feed>> watchFeeds();

  Future<Feed?> getFeed(String id);

  /// Validates, fetches, and persists a new subscription.
  Future<Feed> subscribe(Uri url);

  Future<void> unsubscribe(String id);

  Future<FeedRefreshResult> refresh(String id);

  Future<List<FeedRefreshResult>> refreshAll();
}
