import 'dart:async';
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

    try {
      return await _download(
        request,
        fallbackUri: uri,
        etag: etag,
        lastModified: lastModified,
      ).timeout(timeout);
    } on TimeoutException {
      throw FeedFetchException(
        'Feed download timed out after ${timeout.inMilliseconds} ms.',
      );
    } on FeedFetchException {
      rethrow;
    } catch (error) {
      throw FeedFetchException('Could not download the feed: $error');
    }
  }

  Future<FeedFetchResult> _download(
    http.BaseRequest request, {
    required Uri fallbackUri,
    required String? etag,
    required String? lastModified,
  }) async {
    final response = await _client.send(request);

    final responseEtag = response.headers['etag'] ?? etag;
    final responseLastModified =
        response.headers['last-modified'] ?? lastModified;
    final sourceUri = switch (response) {
      http.BaseResponseWithUrl(:final url) => url,
      _ => response.request?.url ?? fallbackUri,
    };

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
      if (chunk.length > maximumBytes - bytes.length) {
        throw FeedFetchException(
          'Feed is larger than the $maximumBytes byte download limit.',
        );
      }
      bytes.add(chunk);
    }

    return FeedDocumentFetched(
      sourceUri: sourceUri,
      etag: responseEtag,
      lastModified: responseLastModified,
      document: utf8.decode(bytes.takeBytes(), allowMalformed: true),
    );
  }
}
