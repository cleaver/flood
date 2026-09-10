# Flood — Product Brief

## Product concept

Flood is a calm, fast RSS reader for people who follow a small set of trusted sources and want to read without an algorithmic feed. It makes subscriptions, unread items, and saved articles reliable across bad connections.

## Target user

An intentional reader who follows roughly 5–50 blogs, news sites, newsletters, or podcasts, checks in daily or weekly, and values chronological control, privacy, and offline access.

## Problem

RSS is the most direct way to follow independent publishing, but readers can feel cluttered, slow, or unreliable when feeds are malformed or connectivity is weak. Readers need a simple place to catch up without losing their reading state.

## MVP promise

“Add the feeds you trust, see what is new, and keep reading even when you are offline.”

## MVP goals

- Subscribe by feed URL and handle RSS 1.0, RSS 2.0, and Atom.
- Present a chronological, unified inbox that opens quickly from cached data.
- Let people read, save/star, and mark items read or unread.
- Persist feeds, articles, and reading state locally.
- Make refresh status and feed failures understandable and recoverable.

## Explicit non-goals for v1

- Accounts, sign-in, or cross-device sync.
- Algorithmic ranking, recommendations, or AI summaries.
- Full-text scraping or bypassing publisher pages/paywalls.
- Push notifications and background refresh guarantees.
- Podcast playback, social features, and browser extensions.

## Core screens

- **Timeline:** unified chronological inbox with All, Unread, and Saved filters.
- **Subscriptions:** add, manage, retry, and remove feeds.
- **Article:** supplied feed content plus save, mark unread, share, and open-original actions.
- **Settings:** appearance, reading preferences, local article retention, and data controls.

## First-beta success criteria

- A reader can add a working feed and see articles in under one minute.
- Cached content opens offline after a previous refresh.
- Reading and starred state survive restart and refresh.
- Feed errors identify the affected source and offer retry.
