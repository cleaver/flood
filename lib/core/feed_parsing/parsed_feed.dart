class ParsedFeed {
  const ParsedFeed({
    required this.title,
    required this.articles,
    this.description,
    this.siteUrl,
    this.iconUrl,
  });

  final String title;
  final String? description;
  final Uri? siteUrl;
  final Uri? iconUrl;
  final List<ParsedArticle> articles;
}

class ParsedArticle {
  const ParsedArticle({
    required this.sourceKey,
    required this.title,
    this.url,
    this.author,
    this.summaryHtml,
    this.contentHtml,
    this.publishedAt,
    this.updatedAt,
  });

  final String sourceKey;
  final String title;
  final Uri? url;
  final String? author;
  final String? summaryHtml;
  final String? contentHtml;
  final DateTime? publishedAt;
  final DateTime? updatedAt;
}
