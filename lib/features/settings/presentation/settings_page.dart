import 'package:flutter/material.dart';

import 'package:flood/core/reader/reader_preferences_store.dart';
import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/core/settings/app_settings_store.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.articleRepository,
    required this.appearance,
    required this.onAppearanceChanged,
    this.settings = const SharedPreferencesAppSettingsStore(),
    this.readerPreferences = const SharedPreferencesReaderPreferencesStore(),
    super.key,
  });

  final ArticleRepository articleRepository;
  final AppAppearance appearance;
  final Future<void> Function(AppAppearance) onAppearanceChanged;
  final AppSettingsStore settings;
  final ReaderPreferencesStore readerPreferences;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _originalLinkOpening = OriginalLinkOpening.systemBrowser;
  var _articleRetention = ArticleRetentionPeriod.thirtyDays;
  var _readerFontPairing = ReaderFontPairing.editorial;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final opening = await widget.settings.loadOriginalLinkOpening();
      final retention = await widget.settings.loadArticleRetention();
      final pairing = await widget.readerPreferences.loadFontPairing();
      if (!mounted) return;
      setState(() {
        _originalLinkOpening = opening;
        _articleRetention = retention;
        _readerFontPairing = pairing;
      });
      await _applyRetention(retention);
    } on Object {
      // Settings failures must not prevent access to the rest of the app.
    }
  }

  Future<void> _chooseAppearance() async {
    final choice = await _choose<AppAppearance>(
      title: 'Appearance',
      selected: widget.appearance,
      values: AppAppearance.values,
      label: (value) => value.label,
    );
    if (choice == null || choice == widget.appearance) return;
    try {
      await widget.onAppearanceChanged(choice);
    } on Object {
      _showSaveError();
    }
  }

  Future<void> _chooseReaderFont() async {
    final choice = await _choose<ReaderFontPairing>(
      title: 'Reading font',
      selected: _readerFontPairing,
      values: ReaderFontPairing.values,
      label: _readerFontLabel,
    );
    if (choice == null || choice == _readerFontPairing) return;
    try {
      await widget.readerPreferences.saveFontPairing(choice);
      if (mounted) setState(() => _readerFontPairing = choice);
    } on Object {
      _showSaveError();
    }
  }

  Future<void> _chooseLinkOpening() async {
    final choice = await _choose<OriginalLinkOpening>(
      title: 'Open original links',
      selected: _originalLinkOpening,
      values: OriginalLinkOpening.values,
      label: (value) => value.label,
    );
    if (choice == null || choice == _originalLinkOpening) return;
    try {
      await widget.settings.saveOriginalLinkOpening(choice);
      if (mounted) setState(() => _originalLinkOpening = choice);
    } on Object {
      _showSaveError();
    }
  }

  Future<void> _chooseRetention() async {
    final choice = await _choose<ArticleRetentionPeriod>(
      title: 'Downloaded articles',
      selected: _articleRetention,
      values: ArticleRetentionPeriod.values,
      label: (value) => value.label,
      description: 'Older unsaved articles are removed automatically. Saved articles are kept.',
    );
    if (choice == null || choice == _articleRetention) return;
    try {
      await widget.settings.saveArticleRetention(choice);
    } on Object {
      _showSaveError();
      return;
    }
    if (!mounted) return;
    setState(() => _articleRetention = choice);
    try {
      await _applyRetention(choice);
    } on Object {
      _showMessage('Retention saved, but older articles could not be removed.');
    }
  }

  Future<void> _applyRetention(ArticleRetentionPeriod retention) async {
    final cutoff = retention.cutoffFrom(DateTime.now());
    if (cutoff != null) {
      await widget.articleRepository.deleteArticlesBefore(cutoff);
    }
  }

  Future<T?> _choose<T extends Enum>({
    required String title,
    required T selected,
    required List<T> values,
    required String Function(T) label,
    String? description,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(title),
                subtitle: description == null ? null : Text(description),
              ),
              for (final value in values)
                Semantics(
                  checked: value == selected,
                  child: ListTile(
                    title: Text(label(value)),
                    trailing: value == selected
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => Navigator.of(context).pop(value),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _readerFontLabel(ReaderFontPairing pairing) => switch (pairing) {
    ReaderFontPairing.editorial => 'Editorial',
    ReaderFontPairing.sansSerif => 'Sans serif',
  };

  void _showSaveError() {
    _showMessage('Could not save this setting.');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Appearance'),
            trailing: Text(widget.appearance.label),
            onTap: _chooseAppearance,
          ),
          ListTile(
            leading: const Icon(Icons.text_format),
            title: const Text('Reading font'),
            trailing: Text(_readerFontLabel(_readerFontPairing)),
            onTap: _chooseReaderFont,
          ),
          ListTile(
            leading: const Icon(Icons.open_in_browser_outlined),
            title: const Text('Open original links'),
            trailing: Text(_originalLinkOpening.label),
            onTap: _chooseLinkOpening,
          ),
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text('Downloaded articles'),
            trailing: Text(_articleRetention.label),
            onTap: _chooseRetention,
          ),
        ],
      ),
    );
  }
}
