import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flood/core/content/article_content_formatter.dart';
import 'package:flood/core/models/article_with_state.dart';
import 'package:flood/core/repositories/article_repository.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({
    required this.articleId,
    required this.repository,
    super.key,
  });

  final String articleId;
  final ArticleRepository repository;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool _whiteArticle = false;

  Future<void> _chooseAppearance() async {
    final choice = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Article appearance'),
              subtitle: Text('Choose a comfortable reading surface'),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Follow app appearance'),
              trailing: !_whiteArticle ? const Icon(Icons.check) : null,
              onTap: () => Navigator.of(context).pop(false),
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: const Text('White article'),
              trailing: _whiteArticle ? const Icon(Icons.check) : null,
              onTap: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (choice != null && mounted) setState(() => _whiteArticle = choice);
  }

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
      stream: widget.repository.watchArticle(widget.articleId),
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
        final readerTheme = _whiteArticle
            ? ThemeData.light().copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF0066CC),
                  brightness: Brightness.light,
                ),
                scaffoldBackgroundColor: Colors.white,
              )
            : Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(item.feedTitle),
            actions: [
              IconButton(
                icon: Icon(
                  item.state.isStarred ? Icons.star : Icons.star_outline,
                ),
                onPressed: () => widget.repository.setStarred(
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
              IconButton(
                icon: Icon(
                  _whiteArticle
                      ? Icons.wb_sunny_outlined
                      : Icons.brightness_6_outlined,
                ),
                onPressed: _chooseAppearance,
                tooltip: 'Article appearance',
              ),
            ],
          ),
          body: Theme(
            data: readerTheme,
            child: SelectionArea(
              child: ColoredBox(
                color: readerTheme.scaffoldBackgroundColor,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 48),
                  children: [
                    Text(
                      article.title.isEmpty
                          ? 'Untitled article'
                          : article.title,
                      style: readerTheme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      [
                        if (article.author != null) article.author!,
                        item.feedTitle,
                      ].join(' · '),
                      style: readerTheme.textTheme.bodyMedium?.copyWith(
                        color: readerTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (article.isRemoved)
                      Card(
                        child: ListTile(
                          leading: Tooltip(
                            message: 'Removed from feed',
                            child: Icon(
                              Icons.remove_circle_outline,
                              semanticLabel: 'Removed from feed',
                              color: readerTheme.colorScheme.error,
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
            ),
          ),
        );
      },
    );
  }
}
