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

Flood currently supports a resilient multi-feed reading slice:

1. Add and manage multiple HTTP or HTTPS RSS/Atom feeds from Subscriptions.
2. Fetch, parse, and atomically persist the feed and its articles.
3. Refresh one feed or all feeds; manual refreshes bypass cached validators so
   publisher-side removals are detected, then retry failures.
4. Correct a feed URL safely: Flood verifies and fetches the replacement before
   updating the saved subscription.
5. Filter the reactive timeline by feed, All, Unread, or Saved.
6. Deduplicate entries with the same canonical article URL across feeds while
   keeping each feed's original record.
7. Read feed-supplied HTML, open the original URL, and save an article from a
   timeline row or the reader.

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

## Resilience behavior

- Flood opens its local database before any refresh, so previously downloaded
  feeds and articles remain readable while offline.
- A feed download has a 15-second end-to-end deadline by default; it covers
  both response headers and body bytes.
- HTTP redirects are followed by the platform client. Relative links are then
  resolved against the final feed URL.
- Invalid XML, timeouts, HTTP errors, and oversized responses fail before
  publisher data is written. A failed refresh keeps prior articles available.
- Responses are limited to 5 MiB by default, including protection against a
  single oversized response chunk.
- Missing dates are valid and sort by fetch time. Repeated GUIDs in one feed
  resolve to the final occurrence.
- Routine repository refreshes send HTTP cache validators. Manual refreshes
  intentionally skip them so a stale upstream ETag cannot hide removals.
- Entries absent from a successful refresh are retained and labeled “Removed
  from feed”; a failed or `304 Not Modified` refresh never applies that label.

## Flutter Resources

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
