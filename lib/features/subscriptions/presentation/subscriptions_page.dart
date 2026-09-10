import 'package:flutter/material.dart';

import 'package:flood/core/models/feed.dart';
import 'package:flood/core/models/feed_refresh_result.dart';
import 'package:flood/core/repositories/feed_repository.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({
    required this.repository,
    required this.onSubscribed,
    super.key,
  });

  final FeedRepository repository;
  final VoidCallback onSubscribed;

  Future<void> _addFeed(BuildContext context) async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => AddFeedDialog(repository: repository),
    );
    if (added ?? false) onSubscribed();
  }

  Future<void> _editFeed(BuildContext context, Feed feed) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AddFeedDialog(repository: repository, feed: feed),
    );
  }

  Future<void> _refresh(BuildContext context, Feed feed) async {
    final result = await repository.refresh(feed.id);
    if (context.mounted && result is FeedRefreshFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not refresh ${feed.title}.')),
      );
    }
  }

  Future<void> _remove(BuildContext context, Feed feed) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${feed.title}?'),
        content: const Text(
          'This removes the feed and its downloaded articles from Flood.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await repository.unsubscribe(feed.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscriptions')),
      body: StreamBuilder<List<Feed>>(
        stream: repository.watchFeeds(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load subscriptions.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final feeds = snapshot.data!;
          if (feeds.isEmpty) {
            return Center(
              child: FilledButton.icon(
                onPressed: () => _addFeed(context),
                icon: const Icon(Icons.add),
                label: const Text('Add a feed'),
              ),
            );
          }
          return ListView.separated(
            itemCount: feeds.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final feed = feeds[index];
              return ListTile(
                isThreeLine: feed.refreshError != null,
                leading: const Icon(Icons.rss_feed),
                title: Text(feed.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(feed.url.toString()),
                    if (feed.refreshError case final error?)
                      Text(
                        error,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _refresh(context, feed),
                      icon: const Icon(Icons.refresh),
                      tooltip: feed.refreshError == null
                          ? 'Refresh ${feed.title}'
                          : 'Retry ${feed.title}',
                    ),
                    PopupMenuButton<_FeedAction>(
                      tooltip: 'Manage ${feed.title}',
                      onSelected: (action) {
                        switch (action) {
                          case _FeedAction.edit:
                            _editFeed(context, feed);
                          case _FeedAction.remove:
                            _remove(context, feed);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: _FeedAction.edit,
                          child: Text('Edit URL'),
                        ),
                        PopupMenuItem(
                          value: _FeedAction.remove,
                          child: Text('Remove feed'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addFeed(context),
        tooltip: 'Add a feed',
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum _FeedAction { edit, remove }

class AddFeedDialog extends StatefulWidget {
  const AddFeedDialog({required this.repository, this.feed, super.key});

  final FeedRepository repository;
  final Feed? feed;

  @override
  State<AddFeedDialog> createState() => _AddFeedDialogState();
}

class _AddFeedDialogState extends State<AddFeedDialog> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;
  String? _error;

  bool get _isEditing => widget.feed != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.feed?.url.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final uri = Uri.tryParse(_controller.text.trim());
    if (uri == null ||
        !uri.hasAuthority ||
        !{'http', 'https'}.contains(uri.scheme)) {
      setState(() => _error = 'Enter a complete HTTP or HTTPS feed URL.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      if (widget.feed case final feed?) {
        await widget.repository.updateUrl(feed.id, uri);
      } else {
        await widget.repository.subscribe(uri);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = _isEditing
            ? 'Flood could not update this feed.'
            : 'Flood could not subscribe to this feed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit feed URL' : 'Add a feed'),
      content: TextField(
        key: const Key('feed-url-field'),
        controller: _controller,
        autofocus: true,
        enabled: !_isSubmitting,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: 'Feed URL',
          hintText: 'https://example.com/feed.xml',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  _isEditing
                      ? 'Update and refresh'
                      : _error == null
                      ? 'Subscribe'
                      : 'Try again',
                ),
        ),
      ],
    );
  }
}
