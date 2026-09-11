import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'desktop_window_controller.dart';
import 'window_size_store.dart';

DesktopWindowController? _controller;

Future<void> initializeWindowPersistence() async {
  if (!Platform.isLinux && !Platform.isMacOS && !Platform.isWindows) return;

  final preferences = await SharedPreferences.getInstance();
  _controller = DesktopWindowController(
    SharedPreferencesWindowSizeStore(preferences),
  );
  await _controller!.initialize();
}
