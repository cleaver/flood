import 'package:flood/core/models/article.dart';

/// Returns the conservative identity used to suppress repeated timeline cards.
///
/// Only article URLs can identify an entry across unrelated feeds reliably.
/// URL-less entries deliberately retain their per-feed identity.
String articleDeduplicationKey(Article article) =>
    articleDeduplicationKeyForValues(id: article.id, url: article.url);

String articleDeduplicationKeyForValues({
  required String id,
  required Uri? url,
}) {
  if (url == null || !url.hasAuthority) return 'article:$id';

  final normalized = url.replace(
    scheme: url.scheme.toLowerCase(),
    host: url.host.toLowerCase(),
    fragment: null,
  );
  return 'url:$normalized';
}
