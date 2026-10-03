import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flood/app_dependencies.dart';
import 'package:flood/core/reader/reader_preferences_store.dart';
import 'package:flood/core/settings/app_settings_store.dart';
import 'package:flood/features/app_shell/presentation/app_shell.dart';

class FloodApp extends StatefulWidget {
  const FloodApp({
    super.key,
    this.dependencies,
    this.themeMode,
    this.settings = const SharedPreferencesAppSettingsStore(),
    this.readerPreferences = const SharedPreferencesReaderPreferencesStore(),
  });

  final AppDependencies? dependencies;
  final ThemeMode? themeMode;
  final AppSettingsStore settings;
  final ReaderPreferencesStore readerPreferences;

  @override
  State<FloodApp> createState() => _FloodAppState();
}

class _FloodAppState extends State<FloodApp> {
  late final AppDependencies _dependencies;
  late final bool _ownsDependencies;
  late AppAppearance _appearance;
  var _appearanceManuallyChanged = false;

  @override
  void initState() {
    super.initState();
    _ownsDependencies = widget.dependencies == null;
    _dependencies = widget.dependencies ?? AppDependencies.defaults();
    _appearance = _appearanceFor(widget.themeMode ?? ThemeMode.system);
    if (widget.themeMode == null) _loadAppearance();
  }

  Future<void> _loadAppearance() async {
    try {
      final appearance = await widget.settings.loadAppearance();
      if (mounted && !_appearanceManuallyChanged) {
        setState(() => _appearance = appearance);
      }
    } on Object {
      // Keep the system appearance if preferences cannot be read.
    }
  }

  Future<void> _setAppearance(AppAppearance appearance) async {
    final previous = _appearance;
    _appearanceManuallyChanged = true;
    setState(() => _appearance = appearance);
    try {
      await widget.settings.saveAppearance(appearance);
    } on Object {
      if (mounted) setState(() => _appearance = previous);
      rethrow;
    }
  }

  AppAppearance _appearanceFor(ThemeMode themeMode) => switch (themeMode) {
    ThemeMode.system => AppAppearance.system,
    ThemeMode.light => AppAppearance.light,
    ThemeMode.dark => AppAppearance.dark,
  };

  @override
  void dispose() {
    if (_ownsDependencies) unawaited(_dependencies.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const lightPrimary = Color(0xFF0066CC);
    const darkPrimary = Color(0xFF66ADFF);
    return MaterialApp(
      title: 'Flood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: lightPrimary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F5F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F5F7),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE4E6EA),
          space: 1,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkPrimary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF111214),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111214),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF33363B),
          space: 1,
        ),
        useMaterial3: true,
      ),
      themeMode: switch (_appearance) {
        AppAppearance.system => ThemeMode.system,
        AppAppearance.light => ThemeMode.light,
        AppAppearance.dark => ThemeMode.dark,
      },
      home: AppShell(
        feedRepository: _dependencies.feedRepository,
        articleRepository: _dependencies.articleRepository,
        appearance: _appearance,
        onAppearanceChanged: _setAppearance,
        settings: widget.settings,
        readerPreferences: widget.readerPreferences,
      ),
    );
  }
}
