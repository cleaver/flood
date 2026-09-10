# Flood

A calm, local-first RSS reader built with Flutter.

## Product

The MVP brief is in [docs/product-brief.md](docs/product-brief.md).
The persistence contract is in [docs/data-model.md](docs/data-model.md), with
the initial SQLite schema in [docs/schema-v1.sql](docs/schema-v1.sql).

## Structure

Feature code lives under `lib/features/`. The app shell owns Timeline,
Subscriptions, and Settings; Article is a route entered from Timeline once feed
items exist.

## Getting Started

Flood currently supports its first complete vertical slice:

1. Add an HTTP or HTTPS RSS/Atom feed from Subscriptions.
2. Fetch, parse, and atomically persist the feed and its articles.
3. Refresh one feed or all feeds with HTTP cache validators.
4. Filter the reactive timeline by All, Unread, or Saved.
5. Read feed-supplied HTML, open the original URL, and save an article.

Install dependencies and run the app with:

```sh
flutter pub get
flutter run
```

When the Drift schema changes, regenerate its companion code with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Verify the project with:

```sh
flutter analyze
flutter test
```

The Android release manifest includes network access for feed refreshes.

## Flutter Resources

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
