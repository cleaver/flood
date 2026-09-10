import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flood/core/network/feed_document_fetcher.dart';

void main() {
  final feedUri = Uri.parse('https://example.com/feed.xml');

  test('downloads a feed and preserves cache validators', () async {
    final client = MockClient((request) async {
      expect(request.headers['accept'], contains('application/rss+xml'));
      expect(request.headers['user-agent'], 'Flood RSS Reader/1.0');
      return http.Response(
        '<rss version="2.0"></rss>',
        200,
        request: request,
        headers: {'etag': '"version-1"', 'last-modified': 'yesterday'},
      );
    });

    final result = await FeedDocumentFetcher(client).fetch(feedUri);

    expect(result, isA<FeedDocumentFetched>());
    final fetched = result as FeedDocumentFetched;
    expect(fetched.document, '<rss version="2.0"></rss>');
    expect(fetched.etag, '"version-1"');
    expect(fetched.lastModified, 'yesterday');
  });

  test('sends validators and handles an unchanged feed', () async {
    final client = MockClient((request) async {
      expect(request.headers['if-none-match'], '"version-1"');
      expect(request.headers['if-modified-since'], 'yesterday');
      return http.Response('', 304, request: request);
    });

    final result = await FeedDocumentFetcher(client)
        .fetch(feedUri, etag: '"version-1"', lastModified: 'yesterday');

    expect(result, isA<FeedDocumentNotModified>());
    expect(result.etag, '"version-1"');
  });

  test('rejects unsupported URL schemes before making a request', () async {
    final client = MockClient((_) async => http.Response('', 200));

    expect(
      FeedDocumentFetcher(client).fetch(Uri.parse('file:///feed.xml')),
      throwsA(isA<FeedFetchException>()),
    );
  });

  test('rejects unsuccessful status codes', () async {
    final client = MockClient(
      (request) async => http.Response('missing', 404, request: request),
    );

    expect(
      FeedDocumentFetcher(client).fetch(feedUri),
      throwsA(
        isA<FeedFetchException>().having(
          (error) => error.statusCode,
          'statusCode',
          404,
        ),
      ),
    );
  });

  test('enforces the configured response size limit', () async {
    final client = MockClient.streaming((request, _) async {
      return http.StreamedResponse(
        Stream.value(utf8.encode('oversized')),
        200,
        request: request,
      );
    });

    expect(
      FeedDocumentFetcher(client, maximumBytes: 4).fetch(feedUri),
      throwsA(isA<FeedFetchException>()),
    );
  });
}
