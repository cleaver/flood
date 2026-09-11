import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flood/core/window/window_size_store.dart';

void main() {
  group('WindowSizePolicy', () {
    test('uses the default size when no saved size exists', () {
      expect(WindowSizePolicy.restore(null), WindowSizePolicy.defaultSize);
    });

    test('restores a valid saved size', () {
      const savedSize = Size(1440, 900);

      expect(WindowSizePolicy.restore(savedSize), savedSize);
    });

    test('raises dimensions below the minimum usable size', () {
      expect(
        WindowSizePolicy.restore(const Size(400, 300)),
        WindowSizePolicy.minimumSize,
      );
    });

    test('uses the default for non-finite or excessive dimensions', () {
      expect(
        WindowSizePolicy.restore(const Size(double.nan, 720)),
        WindowSizePolicy.defaultSize,
      );
      expect(
        WindowSizePolicy.restore(
          Size(WindowSizePolicy.maximumSize.width + 1, 720),
        ),
        WindowSizePolicy.defaultSize,
      );
    });
  });

  group('SharedPreferencesWindowSizeStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('returns null until both dimensions have been saved', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesWindowSizeStore(preferences);

      expect(await store.read(), isNull);
    });

    test('round-trips the saved dimensions', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesWindowSizeStore(preferences);
      const size = Size(1200, 800);

      await store.write(size);

      expect(await store.read(), size);
    });

    test('ignores malformed preference values', () async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesWindowSizeStore.widthKey: 'wide',
        SharedPreferencesWindowSizeStore.heightKey: 800,
      });
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesWindowSizeStore(preferences);

      expect(await store.read(), isNull);
    });
  });
}
