import 'package:flutter/material.dart';

import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/models/article_with_state.dart';
import 'package:flood/core/models/feed.dart';
import 'package:flood/core/models/feed_refresh_result.dart';
import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/core/repositories/feed_repository.dart';
import 'package:flood/features/article/presentation/article_page.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({
    required this.feedRepository,
    required this.articleRepository,
    super.key,
  });

  final FeedRepository feedRepository;
  final ArticleRepository articleRepository;

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  static const _allFeeds = '__all_feeds__';

  ArticleScope _scope = ArticleScope.all;
  String? _feedId;

  Future<void> _refresh() async {
    final results = await widget.feedRepository.refreshAll(force: true);
    final failures = results.whereType<FeedRefreshFailure>().length;
    if (mounted && failures > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$failures feed failed to refresh.')),
      );
    }
  }

  Future<void> _openArticle(ArticleWithState item) async {
    await widget.articleRepository.markRead(item.article.id, isRead: true);
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ArticlePage(
          articleId: item.article.id,
          repository: widget.articleRepository,
        ),
      ),
    );
  }

  Future<void> _toggleStar(ArticleWithState item) {
    return widget.articleRepository.setStarred(
      item.article.id,
      isStarred: !item.state.isStarred,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Feed>>(
      stream: widget.feedRepository.watchFeeds(),
      builder: (context, feedSnapshot) {
        final feeds = feedSnapshot.data ?? const <Feed>[];
        final selectedFeedId = feeds.any((feed) => feed.id == _feedId)
            ? _feedId
            : null;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Today'),
            actions: [
              if (feeds.isNotEmpty)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter feeds',
                  initialValue: selectedFeedId ?? _allFeeds,
                  onSelected: (value) {
                    setState(() => _feedId = value == _allFeeds ? null : value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: _allFeeds,
                      child: Text('All feeds'),
                    ),
                    ...feeds.map(
                      (feed) => PopupMenuItem(
                        value: feed.id,
                        child: Text(feed.title),
                      ),
                    ),
                  ],
                ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refresh,
                tooltip: 'Refresh feeds',
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SegmentedButton<ArticleScope>(
                  segments: const [
                    ButtonSegment(value: ArticleScope.all, label: Text('All')),
                    ButtonSegment(
                      value: ArticleScope.unread,
                      label: Text('Unread'),
                    ),
                    ButtonSegment(
                      value: ArticleScope.starred,
                      label: Text('Saved'),
                    ),
                  ],
                  selected: {_scope},
                  onSelectionChanged: (selection) {
                    setState(() => _scope = selection.single);
                  },
                ),
              ),
            ),
          ),
          body: StreamBuilder<List<ArticleWithState>>(
            stream: widget.articleRepository.watchArticles(
              ArticleQuery(scope: _scope, feedId: selectedFeedId),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError || feedSnapshot.hasError) {
                return const Center(
                  child: Text('Could not load the timeline.'),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snapshot.data!;
              return RefreshIndicator(
                onRefresh: _refresh,
                child: items.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 160),
                          Icon(Icons.inbox_outlined, size: 48),
                          SizedBox(height: 16),
                          Center(child: Text('No articles here yet.')),
                        ],
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) => _ArticleTile(
                          item: items[index],
                          onTap: () => _openArticle(items[index]),
                          onToggleStar: () => _toggleStar(items[index]),
                        ),
                      ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({
    required this.item,
    required this.onTap,
    required this.onToggleStar,
  });

  final ArticleWithState item;
  final VoidCallback onTap;
  final VoidCallback onToggleStar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.state.isRead ? Icons.circle_outlined : Icons.circle,
            size: 12,
            color: item.state.isRead
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.primary,
          ),
          if (item.article.isRemoved) ...[
            const SizedBox(width: 8),
            Tooltip(
              message: 'Removed from feed',
              child: Icon(
                Icons.remove_circle_outline,
                semanticLabel: 'Removed from feed',
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
      title: Text(
        item.article.title.isEmpty ? 'Untitled article' : item.article.title,
        style: TextStyle(
          fontWeight: item.state.isRead ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      subtitle: Text(item.feedTitle),
      trailing: IconButton(
        onPressed: onToggleStar,
        icon: Icon(item.state.isStarred ? Icons.star : Icons.star_outline),
        tooltip: item.state.isStarred ? 'Remove from saved' : 'Save article',
      ),
    );
  }
}
