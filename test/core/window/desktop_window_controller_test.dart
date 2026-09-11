import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flood/core/window/desktop_window_controller.dart';
import 'package:flood/core/window/window_size_store.dart';

void main() {
  test('initializes the native window with the restored size', () async {
    final store = _FakeWindowSizeStore(const Size(1440, 900));
    final platform = _FakeDesktopWindowPlatform();
    final controller = DesktopWindowController(store, platform: platform);

    await controller.initialize();
    await Future<void>.delayed(Duration.zero);

    expect(platform.options?.size, const Size(1440, 900));
    expect(platform.options?.minimumSize, WindowSizePolicy.minimumSize);
    expect(platform.preventClose, isTrue);
    expect(platform.isShown, isTrue);
    expect(platform.isFocused, isTrue);
    controller.dispose();
  });

  test('debounces resize writes', () async {
    final store = _FakeWindowSizeStore();
    final platform = _FakeDesktopWindowPlatform();
    final controller = DesktopWindowController(
      store,
      platform: platform,
      writeDelay: const Duration(milliseconds: 5),
    );
    await controller.initialize();

    platform.size = const Size(1100, 700);
    platform.emitResize();
    platform.size = const Size(1200, 800);
    platform.emitResize();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(store.writes, [const Size(1200, 800)]);
    controller.dispose();
  });

  test('does not save maximized or fullscreen bounds', () async {
    final store = _FakeWindowSizeStore();
    final platform = _FakeDesktopWindowPlatform();
    final controller = DesktopWindowController(
      store,
      platform: platform,
      writeDelay: const Duration(milliseconds: 5),
    );
    await controller.initialize();

    platform.size = const Size(1920, 1080);
    platform.maximized = true;
    platform.emitResize();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(store.writes, isEmpty);

    platform.maximized = false;
    platform.emitUnmaximize();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(store.writes, [const Size(1920, 1080)]);
    controller.dispose();
  });

  test('flushes the current size before destroying the window', () async {
    final store = _FakeWindowSizeStore();
    final platform = _FakeDesktopWindowPlatform();
    final controller = DesktopWindowController(store, platform: platform);
    await controller.initialize();

    platform.size = const Size(1000, 700);
    platform.emitClose();
    await Future<void>.delayed(Duration.zero);

    expect(store.writes, [const Size(1000, 700)]);
    expect(platform.isDestroyed, isTrue);
    controller.dispose();
  });
}

class _FakeWindowSizeStore implements WindowSizeStore {
  _FakeWindowSizeStore([this.savedSize]);

  Size? savedSize;
  final writes = <Size>[];

  @override
  Future<Size?> read() async => savedSize;

  @override
  Future<void> write(Size size) async {
    writes.add(size);
    savedSize = size;
  }
}

class _FakeDesktopWindowPlatform implements DesktopWindowPlatform {
  WindowListener? listener;
  WindowOptions? options;
  Size size = WindowSizePolicy.defaultSize;
  bool maximized = false;
  bool fullscreen = false;
  bool preventClose = false;
  bool isShown = false;
  bool isFocused = false;
  bool isDestroyed = false;

  @override
  Future<void> ensureInitialized() async {}

  @override
  void addListener(WindowListener listener) => this.listener = listener;

  @override
  void removeListener(WindowListener listener) {
    if (this.listener == listener) this.listener = null;
  }

  @override
  Future<void> setPreventClose(bool preventClose) async {
    this.preventClose = preventClose;
  }

  @override
  Future<void> waitUntilReadyToShow(
    WindowOptions options,
    VoidCallback onReady,
  ) async {
    this.options = options;
    size = options.size ?? size;
    onReady();
  }

  @override
  Future<void> show() async {
    isShown = true;
  }

  @override
  Future<void> focus() async {
    isFocused = true;
  }

  @override
  Future<bool> isMaximized() async => maximized;

  @override
  Future<bool> isFullScreen() async => fullscreen;

  @override
  Future<Size> getSize() async => size;

  @override
  Future<void> destroy() async {
    isDestroyed = true;
  }

  void emitResize() => listener?.onWindowResize();

  void emitUnmaximize() => listener?.onWindowUnmaximize();

  void emitClose() => listener?.onWindowClose();
}
