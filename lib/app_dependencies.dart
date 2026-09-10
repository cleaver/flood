import 'package:http/http.dart' as http;

import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/feed_parsing/feed_document_parser.dart';
import 'package:flood/core/network/feed_document_fetcher.dart';
import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/core/repositories/drift_article_repository.dart';
import 'package:flood/core/repositories/drift_feed_repository.dart';
import 'package:flood/core/repositories/feed_repository.dart';

class AppDependencies {
  AppDependencies({
    required this.feedRepository,
    required this.articleRepository,
    this.onClose,
  });

  factory AppDependencies.defaults() {
    final database = FloodDatabase();
    final client = http.Client();
    final source = FeedLoader(
      fetcher: FeedDocumentFetcher(client),
      parser: const FeedDocumentParser(),
    );
    return AppDependencies(
      feedRepository: DriftFeedRepository(database, source),
      articleRepository: DriftArticleRepository(database),
      onClose: () async {
        client.close();
        await database.close();
      },
    );
  }

  final FeedRepository feedRepository;
  final ArticleRepository articleRepository;
  final Future<void> Function()? onClose;

  Future<void> close() async => onClose?.call();
}
