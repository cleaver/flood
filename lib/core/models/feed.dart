class Feed {
  const Feed({
    required this.id,
    required this.url,
    required this.title,
    required this.createdAt,
    this.siteUrl,
    this.description,
    this.iconUrl,
    this.lastRefreshAttemptAt,
    this.lastSuccessfulRefreshAt,
    this.refreshError,
  });

  final String id;
  final Uri url;
  final String title;
  final DateTime createdAt;
  final Uri? siteUrl;
  final String? description;
  final Uri? iconUrl;
  final DateTime? lastRefreshAttemptAt;
  final DateTime? lastSuccessfulRefreshAt;
  final String? refreshError;
}
