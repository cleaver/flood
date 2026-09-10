import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:flood/core/feed_parsing/feed_document_parser.dart';

void main() {
  const parser = FeedDocumentParser();

  String fixture(String name) =>
      File('test/fixtures/feeds/$name').readAsStringSync();

  test('normalizes RSS 2.0 without losing article content', () {
    final feed = parser.parse(
      fixture('rss2.xml'),
      sourceUri: Uri.parse('https://example.com/feed.xml'),
    );

    expect(feed.title, 'Flood Journal');
    expect(feed.siteUrl, Uri.parse('https://example.com/'));
    expect(feed.articles, hasLength(1));
    expect(feed.articles.single.sourceKey, 'post-1');
    expect(
      feed.articles.single.url,
      Uri.parse('https://example.com/posts/first'),
    );
    expect(feed.articles.single.summaryHtml, '<p>Short summary.</p>');
    expect(feed.articles.single.contentHtml, '<p>The complete article.</p>');
    expect(feed.articles.single.publishedAt, DateTime.utc(2002, 10, 2, 13));
  });

  test('normalizes Atom links, identity, author, and dates', () {
    final feed = parser.parse(
      fixture('atom.xml'),
      sourceUri: Uri.parse('https://atom.example.com/feed.xml'),
    );

    final article = feed.articles.single;
    expect(feed.title, 'Flood Atom');
    expect(article.sourceKey, 'tag:atom.example.com,2026:one');
    expect(article.url, Uri.parse('https://atom.example.com/entries/one'));
    expect(article.author, 'River Writer');
    expect(article.publishedAt, DateTime.utc(2026, 1, 3, 10));
    expect(article.updatedAt, DateTime.utc(2026, 1, 4, 11));
  });

  test('normalizes RSS 1.0 and Dublin Core fields', () {
    final feed = parser.parse(
      fixture('rss1.xml'),
      sourceUri: Uri.parse('https://rss1.example.com/feed'),
    );

    final article = feed.articles.single;
    expect(feed.title, 'Flood RDF');
    expect(article.sourceKey, 'rdf-item-1');
    expect(article.author, 'RDF Writer');
    expect(article.publishedAt, DateTime.utc(2026, 1, 5, 9, 30));
  });

  test('normalizes RFC dates with numeric timezone offsets', () {
    final document = fixture('rss2.xml').replaceFirst(
      'Wed, 02 Oct 2002 13:00:00 GMT',
      'Wed, 02 Oct 2002 13:00:00 -0400',
    );

    final feed = parser.parse(
      document,
      sourceUri: Uri.parse('https://example.com/feed.xml'),
    );

    expect(feed.articles.single.publishedAt, DateTime.utc(2002, 10, 2, 17));
  });

  test('accepts an article with no published or updated date', () {
    const document = '''
<rss version="2.0">
  <channel>
    <title>Undated feed</title>
    <link>https://example.com/</link>
    <item>
      <guid>undated-article</guid>
      <title>Undated article</title>
      <link>https://example.com/undated</link>
    </item>
  </channel>
</rss>''';

    final feed = parser.parse(
      document,
      sourceUri: Uri.parse('https://example.com/feed.xml'),
    );

    expect(feed.articles.single.sourceKey, 'undated-article');
    expect(feed.articles.single.publishedAt, isNull);
    expect(feed.articles.single.updatedAt, isNull);
  });

  test('retains duplicate GUID entries for repository reconciliation', () {
    const document = '''
<rss version="2.0">
  <channel>
    <title>Revisions</title>
    <link>https://example.com/</link>
    <item><guid>revised</guid><title>First revision</title></item>
    <item><guid>revised</guid><title>Latest revision</title></item>
  </channel>
</rss>''';

    final feed = parser.parse(
      document,
      sourceUri: Uri.parse('https://example.com/feed.xml'),
    );

    expect(feed.articles, hasLength(2));
    expect(
      feed.articles.map((article) => article.sourceKey),
      everyElement('revised'),
    );
  });

  test('wraps malformed XML in a domain-specific exception', () {
    expect(
      () => parser.parse(
        fixture('malformed.xml'),
        sourceUri: Uri.parse('https://example.com/feed.xml'),
      ),
      throwsA(isA<FeedParseException>()),
    );
  });
}
