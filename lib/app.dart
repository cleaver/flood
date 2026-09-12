import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flood/app_dependencies.dart';
import 'package:flood/features/app_shell/presentation/app_shell.dart';

class FloodApp extends StatefulWidget {
  const FloodApp({super.key, this.dependencies, this.themeMode});

  final AppDependencies? dependencies;
  final ThemeMode? themeMode;

  @override
  State<FloodApp> createState() => _FloodAppState();
}

class _FloodAppState extends State<FloodApp> {
  late final AppDependencies _dependencies;
  late final bool _ownsDependencies;

  @override
  void initState() {
    super.initState();
    _ownsDependencies = widget.dependencies == null;
    _dependencies = widget.dependencies ?? AppDependencies.defaults();
  }

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
      themeMode: widget.themeMode ?? ThemeMode.system,
      home: AppShell(
        feedRepository: _dependencies.feedRepository,
        articleRepository: _dependencies.articleRepository,
      ),
    );
  }
}
