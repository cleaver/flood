import 'package:flutter/material.dart';

import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/core/repositories/feed_repository.dart';
import 'package:flood/features/settings/presentation/settings_page.dart';
import 'package:flood/features/subscriptions/presentation/subscriptions_page.dart';
import 'package:flood/features/timeline/presentation/timeline_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.feedRepository,
    required this.articleRepository,
    super.key,
  });

  final FeedRepository feedRepository;
  final ArticleRepository articleRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      TimelinePage(
        feedRepository: widget.feedRepository,
        articleRepository: widget.articleRepository,
      ),
      SubscriptionsPage(
        repository: widget.feedRepository,
        onSubscribed: () => setState(() => _currentIndex = 0),
      ),
      const SettingsPage(),
    ];
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox),
            label: 'Timeline',
          ),
          NavigationDestination(
            icon: Icon(Icons.rss_feed_outlined),
            selectedIcon: Icon(Icons.rss_feed),
            label: 'Subscriptions',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
