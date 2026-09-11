import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class WindowSizeStore {
  Future<Size?> read();

  Future<void> write(Size size);
}

class WindowSizePolicy {
  const WindowSizePolicy._();

  static const defaultSize = Size(1280, 720);
  static const minimumSize = Size(640, 480);
  static const maximumSize = Size(16384, 16384);

  static Size restore(Size? savedSize) {
    if (savedSize == null || !_isWithinBounds(savedSize)) {
      return defaultSize;
    }

    return Size(
      savedSize.width < minimumSize.width ? minimumSize.width : savedSize.width,
      savedSize.height < minimumSize.height
          ? minimumSize.height
          : savedSize.height,
    );
  }

  static bool _isWithinBounds(Size size) {
    return size.width.isFinite &&
        size.height.isFinite &&
        size.width > 0 &&
        size.height > 0 &&
        size.width <= maximumSize.width &&
        size.height <= maximumSize.height;
  }
}

class SharedPreferencesWindowSizeStore implements WindowSizeStore {
  const SharedPreferencesWindowSizeStore(this._preferences);

  static const widthKey = 'flood.window.width';
  static const heightKey = 'flood.window.height';

  final SharedPreferences _preferences;

  @override
  Future<Size?> read() async {
    final width = _readNumber(widthKey);
    final height = _readNumber(heightKey);
    if (width == null || height == null) return null;
    return Size(width, height);
  }

  @override
  Future<void> write(Size size) async {
    await _preferences.setDouble(widthKey, size.width);
    await _preferences.setDouble(heightKey, size.height);
  }

  double? _readNumber(String key) {
    final value = _preferences.get(key);
    return value is num ? value.toDouble() : null;
  }
}
