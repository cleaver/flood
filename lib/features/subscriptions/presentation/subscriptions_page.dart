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

  Future<void> _refresh(BuildContext context, Feed feed) async {
    final result = await repository.refresh(feed.id);
    if (context.mounted && result is FeedRefreshFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not refresh ${feed.title}.')),
      );
    }
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
                leading: const Icon(Icons.rss_feed),
                title: Text(feed.title),
                subtitle: Text(feed.refreshError ?? feed.url.toString()),
                trailing: IconButton(
                  onPressed: () => _refresh(context, feed),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh ${feed.title}',
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

class AddFeedDialog extends StatefulWidget {
  const AddFeedDialog({required this.repository, super.key});

  final FeedRepository repository;

  @override
  State<AddFeedDialog> createState() => _AddFeedDialogState();
}

class _AddFeedDialogState extends State<AddFeedDialog> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _subscribe() async {
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
      await widget.repository.subscribe(uri);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = 'Flood could not subscribe to this feed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a feed'),
      content: TextField(
        key: const Key('feed-url-field'),
        controller: _controller,
        autofocus: true,
        enabled: !_isSubmitting,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _subscribe(),
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
          onPressed: _isSubmitting ? null : _subscribe,
          child: _isSubmitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Subscribe'),
        ),
      ],
    );
  }
}
