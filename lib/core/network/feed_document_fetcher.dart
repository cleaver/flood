import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class FeedFetchException implements Exception {
  const FeedFetchException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'FeedFetchException: $message';
}

sealed class FeedFetchResult {
  const FeedFetchResult({
    required this.sourceUri,
    required this.etag,
    required this.lastModified,
  });

  final Uri sourceUri;
  final String? etag;
  final String? lastModified;
}

final class FeedDocumentFetched extends FeedFetchResult {
  const FeedDocumentFetched({
    required super.sourceUri,
    required super.etag,
    required super.lastModified,
    required this.document,
  });

  final String document;
}

final class FeedDocumentNotModified extends FeedFetchResult {
  const FeedDocumentNotModified({
    required super.sourceUri,
    required super.etag,
    required super.lastModified,
  });
}

class FeedDocumentFetcher {
  FeedDocumentFetcher(
    this._client, {
    this.timeout = const Duration(seconds: 15),
    this.maximumBytes = 5 * 1024 * 1024,
  });

  final http.Client _client;
  final Duration timeout;
  final int maximumBytes;

  Future<FeedFetchResult> fetch(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    if (!uri.hasAuthority || (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw const FeedFetchException('Feed URLs must use HTTP or HTTPS.');
    }

    final request = http.Request('GET', uri)
      ..headers['accept'] = 'application/atom+xml, application/rss+xml, application/xml, text/xml;q=0.9, */*;q=0.1'
      ..headers['user-agent'] = 'Flood RSS Reader/1.0';
    if (etag != null) request.headers['if-none-match'] = etag;
    if (lastModified != null) {
      request.headers['if-modified-since'] = lastModified;
    }

    late http.StreamedResponse response;
    try {
      response = await _client.send(request).timeout(timeout);
    } on FeedFetchException {
      rethrow;
    } catch (error) {
      throw FeedFetchException('Could not download the feed: $error');
    }

    final responseEtag = response.headers['etag'] ?? etag;
    final responseLastModified =
        response.headers['last-modified'] ?? lastModified;
    final sourceUri = response.request?.url ?? uri;

    if (response.statusCode == 304) {
      return FeedDocumentNotModified(
        sourceUri: sourceUri,
        etag: responseEtag,
        lastModified: responseLastModified,
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw FeedFetchException(
        'Feed request failed with HTTP ${response.statusCode}.',
        statusCode: response.statusCode,
      );
    }

    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response.stream) {
      bytes.add(chunk);
      if (bytes.length > maximumBytes) {
        throw FeedFetchException(
          'Feed is larger than the $maximumBytes byte download limit.',
        );
      }
    }

    return FeedDocumentFetched(
      sourceUri: sourceUri,
      etag: responseEtag,
      lastModified: responseLastModified,
      document: utf8.decode(bytes.takeBytes(), allowMalformed: true),
    );
  }
}
