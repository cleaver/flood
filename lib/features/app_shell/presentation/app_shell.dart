import 'package:flutter/material.dart';

import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/core/repositories/feed_repository.dart';
import 'package:flood/core/reader/reader_preferences_store.dart';
import 'package:flood/core/settings/app_settings_store.dart';
import 'package:flood/features/settings/presentation/settings_page.dart';
import 'package:flood/features/subscriptions/presentation/subscriptions_page.dart';
import 'package:flood/features/timeline/presentation/timeline_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.feedRepository,
    required this.articleRepository,
    required this.appearance,
    required this.onAppearanceChanged,
    required this.settings,
    required this.readerPreferences,
    super.key,
  });

  final FeedRepository feedRepository;
  final ArticleRepository articleRepository;
  final AppAppearance appearance;
  final Future<void> Function(AppAppearance) onAppearanceChanged;
  final AppSettingsStore settings;
  final ReaderPreferencesStore readerPreferences;

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
        settings: widget.settings,
      ),
      SubscriptionsPage(
        repository: widget.feedRepository,
        onSubscribed: () => setState(() => _currentIndex = 0),
      ),
      SettingsPage(
        articleRepository: widget.articleRepository,
        appearance: widget.appearance,
        onAppearanceChanged: widget.onAppearanceChanged,
        settings: widget.settings,
        readerPreferences: widget.readerPreferences,
      ),
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
