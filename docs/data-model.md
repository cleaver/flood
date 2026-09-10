# Flood data model

The version-one schema is defined in [schema-v1.sql](schema-v1.sql). Timestamps
are stored as UTC Unix milliseconds. URLs are stored as normalized strings.

## Ownership

- `feeds` stores subscriptions and conditional-request metadata (`etag` and
  `last_modified`). A feed also owns its latest refresh status.
- `articles` stores publisher-controlled data. `source_key` is the feed GUID,
  canonical URL, or a deterministic fallback hash, in that order.
- `article_states` stores reader-controlled data separately, so refreshing an
  article can never overwrite read, starred, or scroll state.

Deleting a feed cascades to its articles and their state. Retention cleanup must
exclude starred articles. Feed URLs are unique after normalization, and article
identity is unique within a feed.

## Repository boundary

`FeedRepository` owns subscription and refresh workflows. `ArticleRepository`
owns timeline queries and reader state. Both expose streams so the UI can render
local data immediately and react when a refresh updates the database.

The interfaces are storage-agnostic. The first implementation can use Drift and
SQLite without leaking Drift types into the feature UI.

## Feed ingestion boundary

`FeedDocumentFetcher` accepts an injected HTTP client, follows the platform
client's redirect policy, sends stored cache validators, and limits response
size. `FeedDocumentParser` converts supported XML formats into `ParsedFeed`
without assigning database IDs. The repository will join these operations and
persist the result in the next slice.
