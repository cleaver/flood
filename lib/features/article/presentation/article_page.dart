import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flood/core/content/article_content_formatter.dart';
import 'package:flood/core/models/article_with_state.dart';
import 'package:flood/core/repositories/article_repository.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    required this.articleId,
    required this.repository,
    super.key,
  });

  final String articleId;
  final ArticleRepository repository;

  Future<void> _openUrl(BuildContext context, Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleWithState?>(
      stream: repository.watchArticle(articleId),
      builder: (context, snapshot) {
        final item = snapshot.data;
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Could not load this article.')),
          );
        }
        if (item == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final article = item.article;
        final content = const ArticleContentFormatter().format(
          article.contentHtml ?? article.summaryHtml,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(item.feedTitle),
            actions: [
              IconButton(
                icon: Icon(
                  item.state.isStarred ? Icons.star : Icons.star_outline,
                ),
                onPressed: () => repository.setStarred(
                  article.id,
                  isStarred: !item.state.isStarred,
                ),
                tooltip: item.state.isStarred
                    ? 'Remove from saved'
                    : 'Save article',
              ),
              if (article.url case final url?)
                IconButton(
                  icon: const Icon(Icons.open_in_browser_outlined),
                  onPressed: () => _openUrl(context, url),
                  tooltip: 'Open original article',
                ),
            ],
          ),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
              children: [
                Text(
                  article.title.isEmpty ? 'Untitled article' : article.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  [
                    if (article.author != null) article.author!,
                    item.feedTitle,
                  ].join(' · '),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 32),
                if (article.isRemoved)
                  Card(
                    child: ListTile(
                      leading: Tooltip(
                        message: 'Removed from feed',
                        child: Icon(
                          Icons.remove_circle_outline,
                          semanticLabel: 'Removed from feed',
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      title: const Text('Removed from feed'),
                      subtitle: const Text(
                        'This entry is no longer published by this feed.',
                      ),
                    ),
                  ),
                if (article.isRemoved) const SizedBox(height: 16),
                if (content == null || content.trim().isEmpty)
                  const Text('This feed did not include article content.')
                else
                  HtmlWidget(
                    content,
                    baseUrl: article.url,
                    onTapUrl: (value) async {
                      final url = Uri.tryParse(value);
                      if (url == null) return false;
                      await _openUrl(context, url);
                      return true;
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
