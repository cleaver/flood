PRAGMA foreign_keys = ON;

CREATE TABLE feeds (
  id TEXT PRIMARY KEY NOT NULL,
  url TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  site_url TEXT,
  description TEXT,
  icon_url TEXT,
  etag TEXT,
  last_modified TEXT,
  last_refresh_attempt_at INTEGER,
  last_successful_refresh_at INTEGER,
  refresh_error TEXT,
  created_at INTEGER NOT NULL
);

CREATE TABLE articles (
  id TEXT PRIMARY KEY NOT NULL,
  feed_id TEXT NOT NULL REFERENCES feeds(id) ON DELETE CASCADE,
  source_key TEXT NOT NULL,
  url TEXT,
  title TEXT NOT NULL,
  author TEXT,
  summary_html TEXT,
  content_html TEXT,
  published_at INTEGER,
  updated_at INTEGER,
  fetched_at INTEGER NOT NULL,
  UNIQUE (feed_id, source_key)
);

CREATE TABLE article_states (
  article_id TEXT PRIMARY KEY NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  read_at INTEGER,
  is_starred INTEGER NOT NULL DEFAULT 0 CHECK (is_starred IN (0, 1)),
  scroll_offset REAL NOT NULL DEFAULT 0 CHECK (scroll_offset >= 0)
);

CREATE INDEX articles_timeline_idx
  ON articles(COALESCE(published_at, updated_at, fetched_at) DESC);

CREATE INDEX articles_feed_timeline_idx
  ON articles(feed_id, COALESCE(published_at, updated_at, fetched_at) DESC);

CREATE INDEX article_states_starred_idx
  ON article_states(is_starred)
  WHERE is_starred = 1;
