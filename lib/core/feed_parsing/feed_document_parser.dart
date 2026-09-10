import 'package:http_parser/http_parser.dart';
import 'package:rss_feed_parser/domain/rss1_feed.dart';
import 'package:rss_feed_parser/rss_feed_parser.dart';

import 'package:flood/core/feed_parsing/parsed_feed.dart';

class FeedParseException implements FormatException {
  const FeedParseException(this.message, {this.source});

  @override
  final String message;

  @override
  final Object? source;

  @override
  int? get offset => null;

  @override
  String toString() => 'FeedParseException: $message';
}

class FeedDocumentParser {
  const FeedDocumentParser();

  ParsedFeed parse(String document, {required Uri sourceUri}) {
    try {
      return switch (RssFeedParser.detectRssVersion(document)) {
        RssVersion.rss1 => _parseRss1(Rss1Feed.parse(document), sourceUri),
        RssVersion.rss2 => _parseRss2(RssFeed.parse(document), sourceUri),
        RssVersion.atom => _parseAtom(AtomFeed.parse(document), sourceUri),
        RssVersion.unknown => throw const FeedParseException(
          'The document is not a supported RSS or Atom feed.',
        ),
      };
    } on FeedParseException {
      rethrow;
    } catch (error) {
      throw FeedParseException(
        'The feed XML could not be parsed.',
        source: error,
      );
    }
  }

  ParsedFeed _parseRss2(RssFeed feed, Uri sourceUri) {
    final siteUrl = _uri(feed.link, sourceUri);
    return ParsedFeed(
      title: _text(feed.title),
      description: _optionalText(feed.description),
      siteUrl: siteUrl,
      iconUrl: _uri(feed.image?.url, siteUrl ?? sourceUri),
      articles: feed.items
          .map((item) {
            final url = _uri(item.link, siteUrl ?? sourceUri);
            final publishedAt = _date(item.pubDate ?? item.dc?.date);
            final title = _text(item.title ?? item.dc?.title);
            return ParsedArticle(
              sourceKey: _sourceKey(
                explicitId: item.guid,
                url: url,
                title: title,
                date: publishedAt,
              ),
              title: title,
              url: url,
              author: _optionalText(item.author ?? item.dc?.creator),
              summaryHtml: _optionalText(
                item.description ?? item.dc?.description,
              ),
              contentHtml: _optionalText(item.content?.value),
              publishedAt: publishedAt,
            );
          })
          .toList(growable: false),
    );
  }

  ParsedFeed _parseAtom(AtomFeed feed, Uri sourceUri) {
    final siteUrl = _atomLink(feed.links, sourceUri);
    return ParsedFeed(
      title: _text(feed.title),
      description: _optionalText(feed.subtitle),
      siteUrl: siteUrl,
      iconUrl: _uri(feed.icon ?? feed.logo, siteUrl ?? sourceUri),
      articles: feed.items
          .map((item) {
            final url = _atomLink(item.links, siteUrl ?? sourceUri);
            final publishedAt = _date(item.published);
            final updatedAt = _date(item.updated);
            final title = _text(item.title);
            return ParsedArticle(
              sourceKey: _sourceKey(
                explicitId: item.id,
                url: url,
                title: title,
                date: publishedAt ?? updatedAt,
              ),
              title: title,
              url: url,
              author: item.authors.isEmpty
                  ? null
                  : _optionalText(item.authors.first.name),
              summaryHtml: _optionalText(item.summary),
              contentHtml: _optionalText(item.content),
              publishedAt: publishedAt,
              updatedAt: updatedAt,
            );
          })
          .toList(growable: false),
    );
  }

  ParsedFeed _parseRss1(Rss1Feed feed, Uri sourceUri) {
    final siteUrl = _uri(feed.link, sourceUri);
    return ParsedFeed(
      title: _text(feed.title ?? feed.dc?.title),
      description: _optionalText(feed.description ?? feed.dc?.description),
      siteUrl: siteUrl,
      iconUrl: _uri(feed.image, siteUrl ?? sourceUri),
      articles: feed.items
          .map((item) {
            final url = _uri(item.link, siteUrl ?? sourceUri);
            final publishedAt = _date(item.dc?.date);
            final title = _text(item.title ?? item.dc?.title);
            return ParsedArticle(
              sourceKey: _sourceKey(
                explicitId: item.dc?.identifier,
                url: url,
                title: title,
                date: publishedAt,
              ),
              title: title,
              url: url,
              author: _optionalText(item.dc?.creator),
              summaryHtml: _optionalText(
                item.description ?? item.dc?.description,
              ),
              contentHtml: _optionalText(item.content?.value),
              publishedAt: publishedAt,
            );
          })
          .toList(growable: false),
    );
  }

  Uri? _atomLink(List<AtomLink> links, Uri baseUri) {
    AtomLink? selected;
    for (final link in links) {
      if (link.href != null && (link.rel == null || link.rel == 'alternate')) {
        selected = link;
        break;
      }
    }
    return _uri(selected?.href, baseUri);
  }

  Uri? _uri(String? value, Uri baseUri) {
    final normalized = _optionalText(value);
    if (normalized == null) return null;
    final parsed = Uri.tryParse(normalized);
    if (parsed == null) return null;
    return baseUri.resolveUri(parsed);
  }

  DateTime? _date(String? value) {
    final normalized = _optionalText(value);
    if (normalized == null) return null;

    final isoDate = DateTime.tryParse(normalized);
    if (isoDate != null) return isoDate.toUtc();

    try {
      return parseHttpDate(normalized);
    } on FormatException {
      return _numericOffsetDate(normalized);
    }
  }

  DateTime? _numericOffsetDate(String value) {
    final match = RegExp(
      r'^(?:[A-Za-z]{3},\s*)?(\d{1,2})\s+([A-Za-z]{3})\s+(\d{4})\s+'
      r'(\d{2}):(\d{2})(?::(\d{2}))?\s+([+-])(\d{2})(\d{2})$',
    ).firstMatch(value);
    if (match == null) return null;

    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final month = months[match.group(2)!.toLowerCase()];
    if (month == null) return null;

    final localWallTime = DateTime.utc(
      int.parse(match.group(3)!),
      month,
      int.parse(match.group(1)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6) ?? '0'),
    );
    final offset = Duration(
      hours: int.parse(match.group(8)!),
      minutes: int.parse(match.group(9)!),
    );
    return match.group(7) == '+'
        ? localWallTime.subtract(offset)
        : localWallTime.add(offset);
  }

  String _text(String? value) => value?.trim() ?? '';

  String? _optionalText(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  String _sourceKey({
    required String? explicitId,
    required Uri? url,
    required String title,
    required DateTime? date,
  }) {
    final id = _optionalText(explicitId);
    if (id != null) return id;
    if (url != null) return url.toString();

    final input = '$title\u0000${date?.toIso8601String() ?? ''}';
    var hash = BigInt.parse('cbf29ce484222325', radix: 16);
    final prime = BigInt.parse('100000001b3', radix: 16);
    final mask = BigInt.parse('ffffffffffffffff', radix: 16);
    for (final byte in input.codeUnits) {
      hash ^= BigInt.from(byte);
      hash = (hash * prime) & mask;
    }
    return 'fallback:${hash.toRadixString(16).padLeft(16, '0')}';
  }
}
