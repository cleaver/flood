import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flood/core/reader/reader_preferences_store.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('defaults to editorial and round-trips the selected pairing', () async {
    const store = SharedPreferencesReaderPreferencesStore();

    expect(await store.loadFontPairing(), ReaderFontPairing.editorial);

    await store.saveFontPairing(ReaderFontPairing.sansSerif);

    expect(await store.loadFontPairing(), ReaderFontPairing.sansSerif);
  });

  test('falls back to editorial for an unknown stored value', () async {
    SharedPreferences.setMockInitialValues({'reader.fontPairing': 'unknown'});

    expect(
      await const SharedPreferencesReaderPreferencesStore().loadFontPairing(),
      ReaderFontPairing.editorial,
    );
  });
}
