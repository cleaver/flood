import 'package:shared_preferences/shared_preferences.dart';

enum AppAppearance {
  system,
  light,
  dark;

  String get label => switch (this) {
    system => 'System',
    light => 'Light',
    dark => 'Dark',
  };
}

enum OriginalLinkOpening {
  inAppBrowser,
  systemBrowser;

  String get label => switch (this) {
    inAppBrowser => 'In-app when supported',
    systemBrowser => 'System browser',
  };
}

enum ArticleRetentionPeriod {
  forever(null, 'Forever'),
  sevenDays(7, '7 days'),
  thirtyDays(30, '30 days'),
  ninetyDays(90, '90 days');

  const ArticleRetentionPeriod(this.days, this.label);

  final int? days;
  final String label;

  DateTime? cutoffFrom(DateTime now) {
    final retentionDays = days;
    return retentionDays == null
        ? null
        : now.toUtc().subtract(Duration(days: retentionDays));
  }
}

abstract interface class AppSettingsStore {
  Future<AppAppearance> loadAppearance();

  Future<void> saveAppearance(AppAppearance appearance);

  Future<OriginalLinkOpening> loadOriginalLinkOpening();

  Future<void> saveOriginalLinkOpening(OriginalLinkOpening opening);

  Future<ArticleRetentionPeriod> loadArticleRetention();

  Future<void> saveArticleRetention(ArticleRetentionPeriod retention);
}

class SharedPreferencesAppSettingsStore implements AppSettingsStore {
  const SharedPreferencesAppSettingsStore();

  static const _appearanceKey = 'settings.appearance';
  static const _originalLinkOpeningKey = 'settings.originalLinkOpening';
  static const _articleRetentionKey = 'settings.articleRetention';

  @override
  Future<AppAppearance> loadAppearance() async {
    final preferences = await SharedPreferences.getInstance();
    return _parse(
      AppAppearance.values,
      preferences.getString(_appearanceKey),
      AppAppearance.system,
    );
  }

  @override
  Future<void> saveAppearance(AppAppearance appearance) async {
    await _save(_appearanceKey, appearance.name);
  }

  @override
  Future<OriginalLinkOpening> loadOriginalLinkOpening() async {
    final preferences = await SharedPreferences.getInstance();
    return _parse(
      OriginalLinkOpening.values,
      preferences.getString(_originalLinkOpeningKey),
      OriginalLinkOpening.systemBrowser,
    );
  }

  @override
  Future<void> saveOriginalLinkOpening(OriginalLinkOpening opening) async {
    await _save(_originalLinkOpeningKey, opening.name);
  }

  @override
  Future<ArticleRetentionPeriod> loadArticleRetention() async {
    final preferences = await SharedPreferences.getInstance();
    return _parse(
      ArticleRetentionPeriod.values,
      preferences.getString(_articleRetentionKey),
      ArticleRetentionPeriod.thirtyDays,
    );
  }

  @override
  Future<void> saveArticleRetention(ArticleRetentionPeriod retention) async {
    await _save(_articleRetentionKey, retention.name);
  }

  Future<void> _save(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setString(key, value)) {
      throw StateError('Could not save this setting.');
    }
  }

  T _parse<T extends Enum>(List<T> values, String? value, T fallback) {
    return values.firstWhere(
      (entry) => entry.name == value,
      orElse: () => fallback,
    );
  }
}
