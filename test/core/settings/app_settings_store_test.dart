import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flood/core/settings/app_settings_store.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('uses safe defaults and round-trips each preference', () async {
    const store = SharedPreferencesAppSettingsStore();

    expect(await store.loadAppearance(), AppAppearance.system);
    expect(
      await store.loadOriginalLinkOpening(),
      OriginalLinkOpening.systemBrowser,
    );
    expect(
      await store.loadArticleRetention(),
      ArticleRetentionPeriod.thirtyDays,
    );

    await store.saveAppearance(AppAppearance.dark);
    await store.saveOriginalLinkOpening(OriginalLinkOpening.inAppBrowser);
    await store.saveArticleRetention(ArticleRetentionPeriod.thirtyDays);

    expect(await store.loadAppearance(), AppAppearance.dark);
    expect(
      await store.loadOriginalLinkOpening(),
      OriginalLinkOpening.inAppBrowser,
    );
    expect(
      await store.loadArticleRetention(),
      ArticleRetentionPeriod.thirtyDays,
    );
  });

  test('falls back when a stored value is unknown', () async {
    SharedPreferences.setMockInitialValues({
      'settings.appearance': 'unknown',
      'settings.originalLinkOpening': 'unknown',
      'settings.articleRetention': 'unknown',
    });
    const store = SharedPreferencesAppSettingsStore();

    expect(await store.loadAppearance(), AppAppearance.system);
    expect(
      await store.loadOriginalLinkOpening(),
      OriginalLinkOpening.systemBrowser,
    );
    expect(
      await store.loadArticleRetention(),
      ArticleRetentionPeriod.thirtyDays,
    );
  });

  test('computes retention cutoffs in UTC', () {
    final now = DateTime.parse('2026-10-02T12:00:00-04:00');

    expect(
      ArticleRetentionPeriod.sevenDays.cutoffFrom(now),
      DateTime.utc(2026, 9, 25, 16),
    );
    expect(ArticleRetentionPeriod.forever.cutoffFrom(now), isNull);
  });
}
