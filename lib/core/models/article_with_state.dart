import 'package:flood/core/models/article.dart';
import 'package:flood/core/models/article_state.dart';

class ArticleWithState {
  const ArticleWithState({
    required this.article,
    required this.state,
    required this.feedTitle,
  });

  final Article article;
  final ArticleState state;
  final String feedTitle;
}
