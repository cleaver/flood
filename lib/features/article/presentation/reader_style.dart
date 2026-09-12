import 'package:flutter/material.dart';

import 'package:flood/core/reader/reader_preferences_store.dart';

/// Shared type, spacing, and semantic palette for the article and its previews.
class ReaderStyle {
  const ReaderStyle(this.theme, this.pairing);

  final ThemeData theme;
  final ReaderFontPairing pairing;

  static const columnWidth = 680.0;
  static const displayFamily = 'Inter';

  static String bodyFamily(ReaderFontPairing pairing) => switch (pairing) {
    ReaderFontPairing.editorial => 'Source Serif 4',
    ReaderFontPairing.sansSerif => 'Inter',
  };

  static ThemeData articleTheme(ThemeData appTheme, {required bool white}) =>
      white
      ? ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0066CC),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
        )
      : appTheme;

  TextStyle get body => TextStyle(
    fontFamily: bodyFamily(pairing),
    fontSize: 19,
    height: 1.6,
    letterSpacing: 0,
    color: theme.colorScheme.onSurface,
  );

  TextStyle title({required bool narrow}) => TextStyle(
    fontFamily: displayFamily,
    fontSize: narrow ? 28 : 34,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -.6,
    color: theme.colorScheme.onSurface,
  );

  TextStyle get metadata => TextStyle(
    fontFamily: displayFamily,
    fontSize: 13,
    height: 1.5,
    color: theme.colorScheme.onSurfaceVariant,
  );

  Map<String, String> htmlStyles(String? tag) => switch (tag) {
    'p' => {'margin': '0 0 20px'},
    'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6' => {
      'font-family': displayFamily,
      'font-size': switch (tag) {
        'h1' || 'h2' => '25px',
        'h3' => '22px',
        _ => '19px',
      },
      'font-weight': '600',
      'line-height': '1.3',
      'margin': '32px 0 12px',
    },
    'a' => {
      'color': _cssColor(theme.colorScheme.primary),
      'text-decoration': 'underline',
    },
    'blockquote' => {
      'margin': '24px 0',
      'padding-left': '20px',
      'border-left': '2px solid ${_cssColor(theme.colorScheme.outlineVariant)}',
    },
    'ul' || 'ol' => {'margin': '0 0 20px', 'padding-left': '26px'},
    'li' => {'margin': '0 0 8px'},
    'pre' => {
      'font-size': '15px',
      'line-height': '1.5',
      'background-color': _cssColor(theme.colorScheme.surfaceContainer),
      'padding': '16px',
      'margin': '20px 0',
    },
    'code' || 'kbd' || 'samp' => {
      'font-family': 'monospace',
      'font-size': '0.85em',
      'background-color': _cssColor(theme.colorScheme.surfaceContainer),
    },
    'table' => {'font-size': '16px', 'margin': '20px 0'},
    'th' || 'td' => {
      'padding': '10px 12px',
      'border-bottom':
          '1px solid ${_cssColor(theme.colorScheme.outlineVariant)}',
    },
    'figure' => {'margin': '24px 0'},
    'img' => {'max-width': '100%', 'height': 'auto', 'margin': '24px 0'},
    'figcaption' => {
      'font-family': displayFamily,
      'font-size': '13px',
      'color': _cssColor(theme.colorScheme.onSurfaceVariant),
      'margin-top': '8px',
    },
    'hr' => {
      'color': _cssColor(theme.colorScheme.outlineVariant),
      'margin': '28px 0',
    },
    _ => {},
  };

  static String _cssColor(Color color) =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}
