import 'package:flood/core/models/feed.dart';
import 'package:flood/core/models/feed_refresh_result.dart';

abstract interface class FeedRepository {
  Stream<List<Feed>> watchFeeds();

  Future<Feed?> getFeed(String id);

  /// Validates, fetches, and persists a new subscription.
  Future<Feed> subscribe(Uri url);

  /// Validates and fetches a replacement URL before changing a subscription.
  Future<Feed> updateUrl(String id, Uri url);

  Future<void> unsubscribe(String id);

  /// Refreshes a feed using its cache validators unless [force] is true.
  ///
  /// A forced refresh skips stored validators so a manual refresh can detect
  /// publisher-side changes even when an upstream server reuses a stale ETag.
  Future<FeedRefreshResult> refresh(String id, {bool force = false});

  Future<List<FeedRefreshResult>> refreshAll({bool force = false});
}
