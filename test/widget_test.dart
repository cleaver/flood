import 'dart:ui' show PointerDeviceKind;

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:flood/app.dart';
import 'package:flood/app_dependencies.dart';
import 'package:flood/core/database/flood_database.dart';
import 'package:flood/core/feed_ingestion/feed_loader.dart';
import 'package:flood/core/feed_parsing/parsed_feed.dart';
import 'package:flood/core/repositories/drift_article_repository.dart';
import 'package:flood/core/repositories/drift_feed_repository.dart';

void main() {
  testWidgets(
    'supports reader back navigation across desktop inputs',
    (tester) async {
      final database = FloodDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );
      final feeds = DriftFeedRepository(database, _FixtureSource());
      final articles = DriftArticleRepository(database);
      final dependencies = AppDependencies(
        feedRepository: feeds,
        articleRepository: articles,
      );

      await tester.pumpWidget(
        FloodApp(dependencies: dependencies, themeMode: ThemeMode.dark),
      );
      await tester.pumpAndSettle();
      expect(find.text('No articles here yet.'), findsOneWidget);

      await tester.tap(find.text('Subscriptions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add a feed'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('feed-url-field')),
        'https://example.com/feed.xml',
      );
      await tester.tap(find.text('Subscribe'));
      await tester.pumpAndSettle();

      expect(find.text('First article'), findsOneWidget);
      final usesHorizontalSwipeTransition = switch (defaultTargetPlatform) {
        TargetPlatform.linux ||
        TargetPlatform.macOS ||
        TargetPlatform.windows => true,
        _ => false,
      };
      await tester.tap(find.text('First article'));
      if (usesHorizontalSwipeTransition) {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));
        final enteringArticle = find.text('River Writer · Flood Journal');
        expect(enteringArticle, findsOneWidget);
        final intermediateLeft = tester.getTopLeft(enteringArticle).dx;
        await tester.pumpAndSettle();
        final settledLeft = tester.getTopLeft(enteringArticle).dx;
        expect(intermediateLeft, greaterThan(settledLeft + 20));
      } else {
        await tester.pumpAndSettle();
      }

      expect(find.text('River Writer · Flood Journal'), findsOneWidget);
      final reader = tester.widget<HtmlWidget>(find.byType(HtmlWidget));
      expect(reader.html, contains('<h2>Readable content</h2>'));
      expect(
        reader.textStyle?.color,
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF66ADFF),
          brightness: Brightness.dark,
        ).onSurface,
      );
      await tester.tap(find.byTooltip('Article appearance'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Follow app appearance'), findsNothing);
      expect(find.text('River Writer · Flood Journal'), findsOneWidget);

      await tester.tap(find.byTooltip('Article appearance'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('White article'));
      await tester.pumpAndSettle();
      final whiteReader = tester.widget<HtmlWidget>(find.byType(HtmlWidget));
      expect(
        whiteReader.textStyle?.color,
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
          brightness: Brightness.light,
        ).onSurface,
      );
      await tester.tap(find.byTooltip('Save article'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final stored = await database
          .select(database.articleStateRows)
          .getSingle();
      expect(stored.readAt, isNotNull);
      expect(stored.isStarred, isTrue);

      final isDesktop = switch (defaultTargetPlatform) {
        TargetPlatform.linux ||
        TargetPlatform.macOS ||
        TargetPlatform.windows => true,
        _ => false,
      };
      final usesDartTrackpadPan =
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.windows;

      await _dragMouseRight(tester);
      expect(find.text('River Writer · Flood Journal'), findsOneWidget);

      await _panTrackpad(tester, const Offset(-160, 0));
      expect(find.text('River Writer · Flood Journal'), findsOneWidget);
      await _panTrackpad(tester, const Offset(40, 0));
      expect(find.text('River Writer · Flood Journal'), findsOneWidget);
      await _panTrackpad(tester, const Offset(120, 90));
      expect(find.text('River Writer · Flood Journal'), findsOneWidget);
      await _panTrackpad(tester, const Offset(0, 160));
      expect(find.text('River Writer · Flood Journal'), findsOneWidget);

      if (defaultTargetPlatform == TargetPlatform.macOS) {
        await _sendNativeBackGesture(tester);
      } else {
        await _panTrackpad(tester, const Offset(160, 0));
      }
      if (isDesktop) {
        expect(find.text('River Writer · Flood Journal'), findsNothing);
        expect(find.text('First article'), findsOneWidget);
        await tester.tap(find.text('First article'));
        await tester.pumpAndSettle();
        if (!usesDartTrackpadPan) {
          await _sendNativeBackGesture(tester);
          expect(find.text('River Writer · Flood Journal'), findsNothing);
          await tester.tap(find.text('First article'));
          await tester.pumpAndSettle();
        }
      } else {
        expect(find.text('River Writer · Flood Journal'), findsOneWidget);
      }

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      if (isDesktop) {
        expect(find.text('River Writer · Flood Journal'), findsNothing);
      } else {
        expect(find.text('River Writer · Flood Journal'), findsOneWidget);
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Subscriptions'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Refresh Flood Journal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Timeline'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Removed from feed'), findsOneWidget);

      await tester.tap(find.text('First article'));
      await tester.pumpAndSettle();
      expect(find.text('Removed from feed'), findsOneWidget);
      expect(
        find.text('This entry is no longer published by this feed.'),
        findsOneWidget,
      );
      await database.close();
    },
    variant: TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    }),
  );
}

Future<void> _panTrackpad(WidgetTester tester, Offset delta) async {
  final location = tester.getCenter(find.text('River Writer · Flood Journal'));
  final gesture = await tester.createGesture(kind: PointerDeviceKind.trackpad);
  await gesture.panZoomStart(location);
  await tester.pump();
  for (var step = 1; step <= 4; step++) {
    await gesture.panZoomUpdate(location, pan: delta * (step / 4));
    await tester.pump();
  }
  await gesture.panZoomEnd();
  await tester.pumpAndSettle();
}

Future<void> _dragMouseRight(WidgetTester tester) async {
  final location = tester.getCenter(find.text('River Writer · Flood Journal'));
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.down(location);
  await gesture.moveBy(const Offset(160, 0));
  await gesture.up();
  await tester.pumpAndSettle();
}

Future<void> _sendNativeBackGesture(WidgetTester tester) async {
  final codec = const StandardMethodCodec();
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flood/desktop_navigation',
    codec.encodeMethodCall(const MethodCall('backGesture')),
    (_) {},
  );
  await tester.pumpAndSettle();
}

class _FixtureSource implements FeedSource {
  int _loads = 0;

  @override
  Future<FeedLoadResult> load(
    Uri uri, {
    String? etag,
    String? lastModified,
  }) async {
    _loads++;
    return FeedLoaded(
      etag: '"fixture-v1"',
      lastModified: 'Wed, 09 Sep 2026 12:00:00 GMT',
      feed: ParsedFeed(
        title: 'Flood Journal',
        siteUrl: Uri.parse('https://example.com/'),
        articles: _loads == 1
            ? [
                ParsedArticle(
                  sourceKey: 'article-1',
                  title: 'First article',
                  author: 'River Writer',
                  url: Uri.parse('https://example.com/articles/one'),
                  contentHtml: '## Readable content',
                  publishedAt: DateTime.utc(2026, 9, 8, 10),
                ),
              ]
            : const [],
      ),
    );
  }
}
