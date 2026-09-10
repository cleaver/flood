import 'package:flood/core/feed_parsing/feed_document_parser.dart';
import 'package:flood/core/feed_parsing/parsed_feed.dart';
import 'package:flood/core/network/feed_document_fetcher.dart';

sealed class FeedLoadResult {
  const FeedLoadResult({required this.etag, required this.lastModified});

  final String? etag;
  final String? lastModified;
}

final class FeedLoaded extends FeedLoadResult {
  const FeedLoaded({
    required super.etag,
    required super.lastModified,
    required this.feed,
  });

  final ParsedFeed feed;
}

final class FeedUnchanged extends FeedLoadResult {
  const FeedUnchanged({required super.etag, required super.lastModified});
}

abstract interface class FeedSource {
  Future<FeedLoadResult> load(Uri uri, {String? etag, String? lastModified});
}

class FeedLoader implements FeedSource {
  const FeedLoader({required this.fetcher, required this.parser});

  final FeedDocumentFetcher fetcher;
  final FeedDocumentParser parser;

  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    final result = await fetcher.fetch(
      uri,
      etag: etag,
      lastModified: lastModified,
    );

    return switch (result) {
      FeedDocumentFetched() => FeedLoaded(
        etag: result.etag,
        lastModified: result.lastModified,
        feed: parser.parse(result.document, sourceUri: result.sourceUri),
      ),
      FeedDocumentNotModified() => FeedUnchanged(
        etag: result.etag,
        lastModified: result.lastModified,
      ),
    };
  }
}
