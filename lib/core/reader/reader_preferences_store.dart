import 'package:shared_preferences/shared_preferences.dart';

enum ReaderFontPairing { editorial, sansSerif }

abstract interface class ReaderPreferencesStore {
  Future<ReaderFontPairing> loadFontPairing();
  Future<void> saveFontPairing(ReaderFontPairing pairing);
}

class SharedPreferencesReaderPreferencesStore
    implements ReaderPreferencesStore {
  const SharedPreferencesReaderPreferencesStore();

  static const _fontPairingKey = 'reader.fontPairing';

  @override
  Future<ReaderFontPairing> loadFontPairing() async {
    final preferences = await SharedPreferences.getInstance();
    final stored = preferences.get(_fontPairingKey);
    return ReaderFontPairing.values.firstWhere(
      (pairing) => pairing.name == stored,
      orElse: () => ReaderFontPairing.editorial,
    );
  }

  @override
  Future<void> saveFontPairing(ReaderFontPairing pairing) async {
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setString(_fontPairingKey, pairing.name)) {
      throw StateError('Could not save the reading font.');
    }
  }
}
