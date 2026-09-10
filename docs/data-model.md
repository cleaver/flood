# Flood data model

The version-one schema is defined in [schema-v1.sql](schema-v1.sql). Timestamps
are stored as UTC Unix milliseconds. URLs are stored as normalized strings.

## Ownership

- `feeds` stores subscriptions and conditional-request metadata (`etag` and
  `last_modified`). A feed also owns its latest refresh status.
- `articles` stores publisher-controlled data. `source_key` is the feed GUID,
  canonical URL, or a deterministic fallback hash, in that order.
- `article_states` stores reader-controlled data separately, so refreshing an
  article can never overwrite read, starred, or scroll state. Reader actions
  synchronize across same-URL copies from different feeds.

Deleting a feed removes its articles and their state in the repository
transaction. Retention cleanup must exclude starred articles. Feed URLs are
unique after normalization, and article identity is unique within a feed.

The unified timeline hides repeated copies only when their article URLs match
after lowercasing scheme/host and removing a fragment. URL-less articles are
never collapsed across feeds, avoiding false matches.

## Repository boundary

`FeedRepository` owns subscription and refresh workflows. `ArticleRepository`
owns timeline queries and reader state. Both expose streams so the UI can render
local data immediately and react when a refresh updates the database.

The interfaces are storage-agnostic. The first implementation can use Drift and
SQLite without leaking Drift types into the feature UI.

## Feed ingestion boundary

`FeedDocumentFetcher` accepts an injected HTTP client, follows the platform
client's redirect policy, sends stored cache validators, limits the complete
headers-and-body transaction to 15 seconds by default, and rejects a response
that would exceed its 5 MiB memory budget before buffering the excess chunk.
The final redirect URL becomes the parser's source URI for resolving relative
links.

`FeedDocumentParser` converts supported XML formats into `ParsedFeed` without
assigning database IDs. Missing dates are valid `null` values; article ordering
falls back to fetched time. The repository retains only the last occurrence of
a repeated `source_key` within a feed document, so a repeated GUID becomes a
single latest article. Parse and fetch failures never write publisher data;
failed refreshes retain the existing local article set and record the error on
the feed.
