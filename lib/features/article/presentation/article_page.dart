import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flood/core/content/article_content_formatter.dart';
import 'package:flood/core/content/reader_html_normalizer.dart';
import 'package:flood/core/models/article_with_state.dart';
import 'package:flood/core/reader/reader_preferences_store.dart';
import 'package:flood/core/repositories/article_repository.dart';
import 'package:flood/features/article/presentation/reader_style.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({
    required this.articleId,
    required this.repository,
    this.preferences = const SharedPreferencesReaderPreferencesStore(),
    super.key,
  });

  final String articleId;
  final ArticleRepository repository;
  final ReaderPreferencesStore preferences;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool _whiteArticle = false;
  ReaderFontPairing _fontPairing = ReaderFontPairing.editorial;
  bool _fontPairingManuallySelected = false;
  late Stream<ArticleWithState?> _articleStream;
  ScrollController? _scrollController;
  Timer? _scrollSaveTimer;
  double? _pendingScrollOffset;
  String? _sourceContent;
  String? _readerContent;

  @override
  void initState() {
    super.initState();
    _articleStream = widget.repository.watchArticle(widget.articleId);
    _loadPreferences();
  }

  @override
  void didUpdateWidget(ArticlePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.articleId != widget.articleId ||
        oldWidget.repository != widget.repository) {
      final controller = _scrollController;
      if (controller?.hasClients ?? false) {
        unawaited(
          _persistScrollOffsetFor(
            oldWidget.repository,
            oldWidget.articleId,
            controller!.offset,
          ),
        );
      }
      _scrollSaveTimer?.cancel();
      controller?.dispose();
      _scrollController = null;
      _pendingScrollOffset = null;
      _sourceContent = null;
      _readerContent = null;
      _fontPairing = ReaderFontPairing.editorial;
      _fontPairingManuallySelected = false;
      _articleStream = widget.repository.watchArticle(widget.articleId);
      _loadPreferences();
    }
  }

  Future<void> _loadPreferences() async {
    var pairing = ReaderFontPairing.editorial;
    try {
      pairing = await widget.preferences.loadFontPairing();
    } on Object {
      // A preference failure must not prevent offline reading.
    }
    if (mounted) {
      if (!_fontPairingManuallySelected) {
        setState(() => _fontPairing = pairing);
      }
    }
  }

  Future<void> _chooseAppearance() async {
    final choice = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .85,
      ),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text('Article appearance'),
                subtitle: Text('Reading font'),
              ),
              for (final pairing in ReaderFontPairing.values)
                Semantics(
                  checked: _fontPairing == pairing,
                  child: ListTile(
                    title: Text(
                      pairing == ReaderFontPairing.editorial
                          ? 'Editorial'
                          : 'Sans serif',
                      style: const TextStyle(
                        fontFamily: ReaderStyle.displayFamily,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A quiet place to read.',
                        style: TextStyle(
                          fontFamily: ReaderStyle.bodyFamily(pairing),
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ),
                    trailing: _fontPairing == pairing
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => Navigator.of(context).pop(pairing),
                  ),
                ),
              const Divider(),
              const ListTile(title: Text('Reading surface')),
              ListTile(
                leading: const Icon(Icons.brightness_6_outlined),
                title: const Text('Follow app appearance'),
                trailing: !_whiteArticle ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(false),
              ),
              ListTile(
                leading: const Icon(Icons.wb_sunny_outlined),
                title: const Text('White article'),
                trailing: _whiteArticle ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(true),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (!mounted) return;
    if (choice is bool) {
      setState(() => _whiteArticle = choice);
    } else if (choice is ReaderFontPairing && choice != _fontPairing) {
      _fontPairingManuallySelected = true;
      setState(() => _fontPairing = choice);
      try {
        await widget.preferences.saveFontPairing(choice);
      } on Object {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reading font changed, but could not be remembered.',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _openUrl(BuildContext context, Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this link.')),
      );
    }
  }

  ScrollController _controllerFor(ArticleWithState item) {
    final existing = _scrollController;
    if (existing != null) return existing;

    final controller = ScrollController(
      initialScrollOffset: item.state.scrollOffset,
    )..addListener(_scheduleScrollOffsetSave);
    _scrollController = controller;
    return controller;
  }

  void _scheduleScrollOffsetSave() {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;
    _pendingScrollOffset = controller.offset;
    _scrollSaveTimer?.cancel();
    _scrollSaveTimer = Timer(const Duration(milliseconds: 300), () {
      final offset = _pendingScrollOffset;
      if (offset != null && mounted) {
        unawaited(_persistScrollOffset(offset));
      }
    });
  }

  Future<void> _persistScrollOffset(double offset) async {
    await _persistScrollOffsetFor(widget.repository, widget.articleId, offset);
  }

  Future<void> _persistScrollOffsetFor(
    ArticleRepository repository,
    String articleId,
    double offset,
  ) async {
    try {
      await repository.saveScrollOffset(articleId, offset);
    } on Object {
      // A scroll-state failure must not interrupt reading.
    }
  }

  @override
  void dispose() {
    _scrollSaveTimer?.cancel();
    final controller = _scrollController;
    if (controller?.hasClients ?? false) {
      unawaited(_persistScrollOffset(controller!.offset));
    }
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleWithState?>(
      stream: _articleStream,
      builder: (context, snapshot) {
        final item = snapshot.data;
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Could not load this article.')),
          );
        }
        if (item == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final article = item.article;
        final source = article.contentHtml ?? article.summaryHtml;
        if (source != _sourceContent) {
          _sourceContent = source;
          final formatted = const ArticleContentFormatter().format(source);
          _readerContent = formatted == null
              ? null
              : const ReaderHtmlNormalizer().normalize(formatted);
        }
        final content = _readerContent;
        final readerTheme = ReaderStyle.articleTheme(
          Theme.of(context),
          white: _whiteArticle,
        );
        final style = ReaderStyle(readerTheme, _fontPairing);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              item.feedTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  item.state.isStarred ? Icons.star : Icons.star_outline,
                ),
                onPressed: () => widget.repository.setStarred(
                  article.id,
                  isStarred: !item.state.isStarred,
                ),
                tooltip: item.state.isStarred
                    ? 'Remove from saved'
                    : 'Save article',
              ),
              if (article.url case final url?)
                IconButton(
                  icon: const Icon(Icons.open_in_browser_outlined),
                  onPressed: () => _openUrl(context, url),
                  tooltip: 'Open original article',
                ),
              IconButton(
                icon: const Icon(Icons.text_format),
                onPressed: _chooseAppearance,
                tooltip: 'Article appearance',
              ),
            ],
          ),
          body: Theme(
            data: readerTheme,
            child: DefaultTextStyle(
              style: style.body,
              child: DefaultSelectionStyle(
                selectionColor: readerTheme.colorScheme.primary.withValues(
                  alpha: .25,
                ),
                cursorColor: readerTheme.colorScheme.primary,
                child: SelectionArea(
                  child: ColoredBox(
                    color: readerTheme.scaffoldBackgroundColor,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 720;
                        final side =
                            ((constraints.maxWidth - ReaderStyle.columnWidth) /
                                    2)
                                .clamp(20.0, double.infinity);
                        return ListView(
                          key: PageStorageKey('reader-${article.id}'),
                          controller: _controllerFor(item),
                          padding: EdgeInsets.fromLTRB(
                            side,
                            narrow ? 28 : 48,
                            side,
                            64,
                          ),
                          children: [
                            Text(
                              article.title.isEmpty
                                  ? 'Untitled article'
                                  : article.title,
                              style: style.title(narrow: narrow),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              [
                                if (article.author != null) article.author!,
                                item.feedTitle,
                              ].join(' · '),
                              style: style.metadata,
                            ),
                            const SizedBox(height: 32),
                            if (article.isRemoved)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Tooltip(
                                  message: 'Removed from feed',
                                  child: Icon(
                                    Icons.remove_circle_outline,
                                    semanticLabel: 'Removed from feed',
                                    color: readerTheme
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                title: const Text('Removed from feed'),
                                subtitle: const Text(
                                  'This entry is no longer published by this feed.',
                                ),
                              ),
                            if (article.isRemoved) const SizedBox(height: 16),
                            if (content == null || content.trim().isEmpty)
                              const Text(
                                'This feed did not include article content.',
                              )
                            else
                              HtmlWidget(
                                content,
                                key: ValueKey((
                                  _whiteArticle,
                                  _fontPairing,
                                  readerTheme.brightness,
                                )),
                                baseUrl: article.url,
                                textStyle: style.body,
                                customStylesBuilder: (element) =>
                                    style.htmlStyles(element.localName),
                                onTapUrl: (value) async {
                                  final url = Uri.tryParse(value);
                                  if (url == null) return false;
                                  await _openUrl(context, url);
                                  return true;
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
