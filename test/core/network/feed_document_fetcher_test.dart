import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
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

  test('times out while waiting for response headers', () async {
    final response = Completer<http.Response>();
    final client = MockClient((_) => response.future);

    expect(
      FeedDocumentFetcher(
        client,
        timeout: const Duration(milliseconds: 1),
      ).fetch(feedUri),
      throwsA(
        isA<FeedFetchException>().having(
          (error) => error.message,
          'message',
          contains('timed out'),
        ),
      ),
    );
  });

  test('times out while reading a slow response body', () async {
    final client = MockClient.streaming((request, _) async {
      return http.StreamedResponse(
        Stream.periodic(
          const Duration(seconds: 1),
          (_) => utf8.encode('<rss/>'),
        ).take(1),
        200,
        request: request,
      );
    });

    expect(
      FeedDocumentFetcher(
        client,
        timeout: const Duration(milliseconds: 1),
      ).fetch(feedUri),
      throwsA(isA<FeedFetchException>()),
    );
  });

  test('follows redirects and reports the final source URL', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((request) async {
      if (request.uri.path == '/start') {
        request.response
          ..statusCode = HttpStatus.movedTemporarily
          ..headers.set(HttpHeaders.locationHeader, '/final/feed.xml');
      } else {
        request.response
          ..statusCode = HttpStatus.ok
          ..write('<rss version="2.0"></rss>');
      }
      await request.response.close();
    });
    final client = IOClient();
    addTearDown(client.close);
    final start = Uri.parse(
      'http://${server.address.address}:${server.port}/start',
    );

    final result = await FeedDocumentFetcher(client).fetch(start);

    expect(result, isA<FeedDocumentFetched>());
    expect(result.sourceUri.path, '/final/feed.xml');
  });

  test('rejects an enormous chunk before buffering it', () async {
    final enormousChunk = Uint8List(2 * 1024 * 1024);
    final client = MockClient.streaming((request, _) async {
      return http.StreamedResponse(
        Stream.value(enormousChunk),
        200,
        request: request,
      );
    });

    expect(
      FeedDocumentFetcher(client, maximumBytes: 1024).fetch(feedUri),
      throwsA(isA<FeedFetchException>()),
    );
  });
}
