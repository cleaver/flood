import 'dart:async';
import 'dart:ui';

import 'package:window_manager/window_manager.dart';

import 'window_size_store.dart';

abstract interface class DesktopWindowPlatform {
  Future<void> ensureInitialized();

  void addListener(WindowListener listener);

  void removeListener(WindowListener listener);

  Future<void> setPreventClose(bool preventClose);

  Future<void> waitUntilReadyToShow(
    WindowOptions options,
    VoidCallback onReady,
  );

  Future<void> show();

  Future<void> focus();

  Future<bool> isMaximized();

  Future<bool> isFullScreen();

  Future<Size> getSize();

  Future<void> destroy();
}

class WindowManagerPlatform implements DesktopWindowPlatform {
  WindowManagerPlatform([WindowManager? windowManager])
    : _windowManager = windowManager ?? WindowManager.instance;

  final WindowManager _windowManager;

  @override
  Future<void> ensureInitialized() => _windowManager.ensureInitialized();

  @override
  void addListener(WindowListener listener) =>
      _windowManager.addListener(listener);

  @override
  void removeListener(WindowListener listener) =>
      _windowManager.removeListener(listener);

  @override
  Future<void> setPreventClose(bool preventClose) =>
      _windowManager.setPreventClose(preventClose);

  @override
  Future<void> waitUntilReadyToShow(
    WindowOptions options,
    VoidCallback onReady,
  ) => _windowManager.waitUntilReadyToShow(options, onReady);

  @override
  Future<void> show() => _windowManager.show();

  @override
  Future<void> focus() => _windowManager.focus();

  @override
  Future<bool> isMaximized() => _windowManager.isMaximized();

  @override
  Future<bool> isFullScreen() => _windowManager.isFullScreen();

  @override
  Future<Size> getSize() => _windowManager.getSize();

  @override
  Future<void> destroy() => _windowManager.destroy();
}

class DesktopWindowController with WindowListener {
  DesktopWindowController(
    this._store, {
    DesktopWindowPlatform? platform,
    this.writeDelay = const Duration(milliseconds: 250),
  }) : _platform = platform ?? WindowManagerPlatform();

  final WindowSizeStore _store;
  final DesktopWindowPlatform _platform;
  final Duration writeDelay;

  Timer? _saveTimer;
  bool _initialized = false;
  bool _closing = false;

  Future<void> initialize() async {
    await _platform.ensureInitialized();

    final initialSize = WindowSizePolicy.restore(await _store.read());
    _platform.addListener(this);
    await _platform.setPreventClose(true);
    await _platform.waitUntilReadyToShow(
      WindowOptions(
        size: initialSize,
        minimumSize: WindowSizePolicy.minimumSize,
        title: 'Flood',
      ),
      () => unawaited(_showAndFocus()),
    );
    _initialized = true;
  }

  void dispose() {
    _saveTimer?.cancel();
    _platform.removeListener(this);
  }

  @override
  void onWindowResize() => _scheduleSave();

  @override
  void onWindowResized() => _scheduleSave();

  @override
  void onWindowUnmaximize() => _scheduleSave();

  @override
  void onWindowLeaveFullScreen() => _scheduleSave();

  @override
  void onWindowClose() => unawaited(_closeAndPersist());

  void _scheduleSave() {
    if (!_initialized || _closing) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(writeDelay, () => unawaited(_saveCurrentSize()));
  }

  Future<void> _showAndFocus() async {
    await _platform.show();
    await _platform.focus();
  }

  Future<void> _saveCurrentSize() async {
    try {
      if (await _platform.isMaximized() || await _platform.isFullScreen()) {
        return;
      }
      final currentSize = await _platform.getSize();
      await _store.write(WindowSizePolicy.restore(currentSize));
    } catch (_) {
      // Closing the app should still succeed if the native window disappears
      // while a resize or preference write is in flight.
    }
  }

  Future<void> _closeAndPersist() async {
    if (_closing) return;
    _closing = true;
    _saveTimer?.cancel();
    await _saveCurrentSize();
    await _platform.destroy();
  }
}
