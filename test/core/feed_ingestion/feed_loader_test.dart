import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/feed_parsing/feed_document_parser.dart';
import 'package:flood/core/network/feed_document_fetcher.dart';

void main() {
  test('fetches and parses a saved feed fixture end to end', () async {
    final document = File('test/fixtures/feeds/rss2.xml').readAsStringSync();
    final redirectedUri = Uri.parse('https://example.com/news/feed.xml');
    final client = MockClient((_) async {
      return http.Response(
        document,
        200,
        request: http.Request('GET', redirectedUri),
        headers: {'etag': '"fixture-1"'},
      );
    });
    final loader = FeedLoader(
      fetcher: FeedDocumentFetcher(client),
      parser: const FeedDocumentParser(),
    );

    final result = await loader.load(
      Uri.parse('https://redirect.example/feed'),
    );

    expect(result, isA<FeedLoaded>());
    final loaded = result as FeedLoaded;
    expect(loaded.etag, '"fixture-1"');
    expect(loaded.feed.title, 'Flood Journal');
    expect(
      loaded.feed.articles.single.url,
      Uri.parse('https://example.com/posts/first'),
    );
  });
}
