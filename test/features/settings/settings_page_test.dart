import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flood/app.dart';
import 'package:flood/app_dependencies.dart';
import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/models/article_query.dart';
import 'package:flood/core/models/article_with_state.dart';
import 'package:flood/core/reader/reader_preferences_store.dart';
import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/core/repositories/drift_article_repository.dart';
import 'package:flood/core/repositories/drift_feed_repository.dart';
import 'package:flood/core/settings/app_settings_store.dart';
import 'package:flood/features/settings/presentation/settings_page.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('settings rows edit and persist their choices', (tester) async {
    tester.view.physicalSize = const Size(640, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = FloodDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(database.close);
    final articles = DriftArticleRepository(database);
    final dependencies = AppDependencies(
      feedRepository: DriftFeedRepository(database, _NoFeedSource()),
      articleRepository: articles,
    );
    final settings = const SharedPreferencesAppSettingsStore();
    final readerPreferences = const SharedPreferencesReaderPreferencesStore();

    await tester.pumpWidget(
      FloodApp(
        dependencies: dependencies,
        settings: settings,
        readerPreferences: readerPreferences,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Downloaded articles'), findsOneWidget);
    expect(find.text('30 days'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    expect(find.text('Dark'), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Settings').first)).brightness,
      Brightness.dark,
    );
    expect(await settings.loadAppearance(), AppAppearance.dark);

    await tester.tap(find.text('Reading font'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sans serif'));
    await tester.pumpAndSettle();
    expect(
      await readerPreferences.loadFontPairing(),
      ReaderFontPairing.sansSerif,
    );

    await tester.tap(find.text('Open original links'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('In-app when supported'));
    await tester.pumpAndSettle();
    expect(
      await settings.loadOriginalLinkOpening(),
      OriginalLinkOpening.inAppBrowser,
    );

    await tester.tap(find.text('Downloaded articles'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Older unsaved articles are removed automatically. Saved articles are kept.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('7 days'));
    await tester.pumpAndSettle();
    expect(
      await settings.loadArticleRetention(),
      ArticleRetentionPeriod.sevenDays,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      FloodApp(
        dependencies: dependencies,
        settings: settings,
        readerPreferences: readerPreferences,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Settings').first)).brightness,
      Brightness.dark,
    );
    expect(find.text('Sans serif'), findsOneWidget);
    expect(find.text('In-app when supported'), findsOneWidget);
    expect(find.text('7 days'), findsOneWidget);
  });

  testWidgets('settings remain reachable with enlarged text', (tester) async {
    tester.view.physicalSize = const Size(640, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: SettingsPage(
          articleRepository: _NoArticles(),
          appearance: AppAppearance.system,
          onAppearanceChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Downloaded articles'),
      100,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Downloaded articles'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _NoFeedSource implements FeedSource {
  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    throw StateError('No feeds are used by this test.');
  }
}

class _NoArticles implements ArticleRepository {
  @override
  Stream<List<ArticleWithState>> watchArticles(ArticleQuery query) =>
      Stream.value([]);

  @override
  Stream<ArticleWithState?> watchArticle(String id) => Stream.value(null);

  @override
  Future<void> markRead(String id, {required bool isRead}) async {}

  @override
  Future<void> setStarred(String id, {required bool isStarred}) async {}

  @override
  Future<void> saveScrollOffset(String id, double offset) async {}

  @override
  Future<void> deleteArticlesBefore(DateTime cutoff) async {}
}
