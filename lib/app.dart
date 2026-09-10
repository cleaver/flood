import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flood/app_dependencies.dart';
import 'package:flood/features/app_shell/presentation/app_shell.dart';

class FloodApp extends StatefulWidget {
  const FloodApp({super.key, this.dependencies});

  final AppDependencies? dependencies;

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
    return MaterialApp(
      title: 'Flood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315E8A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9CCBFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: AppShell(
        feedRepository: _dependencies.feedRepository,
        articleRepository: _dependencies.articleRepository,
      ),
    );
  }
}
