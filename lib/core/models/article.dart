class Article {
  const Article({
    required this.id,
    required this.feedId,
    required this.sourceKey,
    required this.title,
    required this.fetchedAt,
    this.url,
    this.author,
    this.summaryHtml,
    this.contentHtml,
    this.publishedAt,
    this.updatedAt,
    this.isRemoved = false,
  });

  final String id;
  final String feedId;

  /// Stable identity from a GUID, canonical URL, or deterministic fallback.
  final String sourceKey;

  final String title;
  final DateTime fetchedAt;
  final Uri? url;
  final String? author;
  final String? summaryHtml;
  final String? contentHtml;
  final DateTime? publishedAt;
  final DateTime? updatedAt;
  final bool isRemoved;

  DateTime get sortDate => publishedAt ?? updatedAt ?? fetchedAt;
}
