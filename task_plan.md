# Task Plan

## Goal

Make Flood's article viewer calm and comfortable to read, with a constrained
column and two selectable font combinations. The default uses editorial serif
prose and sans-serif display text; the alternative uses sans-serif prose.
Remember the choice across articles and launches and retain offline content,
reader actions, and independent article appearance.

## Phases

- [x] Phase 1 — Inspect the viewer, design guide, content pipeline, preferences,
  and existing tests; choose two bundled font combinations.
- [x] Phase 2 — Write and run focused rendered-behavior tests; confirm failures
  for wide content, missing font selection, and publisher color overrides.
- [x] Phase 3 — Implement the first reader layout, typography, HTML normalization,
  font selector with previews, and persisted font preference.
- [x] Phase 4 — Complete regression coverage and resolve integration failures:
  persistence, retained scroll position, rich content, missing content, long
  titles, appearance switching, narrow/wide layouts, and enlarged text.
- [~] Phase 5 — Inspect actual rendering in both font combinations, light/dark/
  white-article appearances, narrow and wide layouts, and 640×480 minimum.
  Responsive rendered behavior and appearance switching are covered by widget
  tests; full-frame raster capture hung in this runner, so manual visual review
  remains to be done in a desktop session.
- [x] Phase 6 — Document fonts and behavior, run `dart format lib test`,
  `flutter analyze`, `flutter test`, and `git diff --check`; review final diff
  and hand off with automated and visual verification distinguished.

## Decisions

- Editorial default: Source Serif 4 prose with Inter titles and headings.
- Sans serif alternative: Inter prose with the same Inter display hierarchy.
- Bundle upright and italic variable fonts and their licenses for offline use.
- Use a 680 logical-pixel maximum column, 19 px body at 1.6 line height,
  responsive 28–34 px title, 13 px metadata, and consistent block spacing.
- Put both choices and short font samples in the existing Article appearance
  sheet. Save the font choice through a separate preferences store using the
  existing shared_preferences dependency.
- Normalize a display-only HTML copy, preserving semantic markup and original
  stored content. Declare the already-transitive html package directly.
- Reuse the HTML renderer's local scrolling for code/tables. Keep reader palette
  separate from app chrome; use a flat opaque canvas and semantic colors.
- User requested `$codex-planning-with-files` after implementation began.
  Maintain these files using that skill; earlier archived plans are historical.

## Errors Encountered

| Error | Attempt | Resolution |
|---|---:|---|
| Initial reader tests: 1240 px prose width, missing Sans serif option, unchanged publisher yellow after appearance switch | 1 | Expected red phase; all three tests now pass |
| Existing app widget test times out opening article | 1 | Resolved by removing the preference loading gate so cached content renders immediately |
| SharedPreferences loading blocked cached article rendering in plugin-less tests | 1 | Removed the render gate; use editorial defaults while loading asynchronously |
| Flutter full-frame screenshot smoke test hung during `RenderRepaintBoundary.toImage` in this runner | 1 | Removed temporary test; rely on rendered widget assertions and report visual limitation |

---

# Desktop reader back navigation

## Goal
Implement Escape and back gestures from the article reader to its existing timeline, preserving reading context.

## Planning phases
1. Inspect current navigation and tests — complete.
2. Verify Flutter and native desktop gesture support — complete for planning; native build and hardware checks remain.
3. Write implementation sequence and acceptance checks — complete.
4. Implement keyboard and gesture back navigation — complete.
5. Validate app checks and inspect platform limits — automated checks and Linux build complete; macOS/Windows native build and hardware checks pending.

## Constraints
- Follow AGENTS.md and the design guide.
- Use focused failing behaviour tests before implementation.
- Preserve list position and article state; avoid interpreting ordinary scrolling as back.

## Errors
- Login shell reports an unrelated broken mise shim; use non-login commands for this task.
- An optional SDK documentation glob had no matches; engine source and official documentation supplied the needed evidence.
- Initial test compilation missed `debugDefaultTargetPlatformOverride`'s foundation import; fixed by using `TargetPlatformVariant`, which manages override cleanup.
- Dart compilation also exposed missing foundation, UI, and async imports for target-platform, pointer-kind, and `unawaited` APIs; added the required imports.
- Initial trackpad test emitted only one pan update, so Flutter correctly produced drag start/end without an update; the test now pumps incremental updates like a real gesture.
- Native macOS and Windows runner builds and hardware checks could not run because this session is on Linux without their SDKs/toolchains.
- Linux host has no Apple or Windows native compiler; native runner changes require validation on those platforms.

## Proposed behaviour
- On Linux, macOS, and Windows, Escape returns from the reader to the existing timeline route, including while article content is loading or has failed.
- A modal, popup, or selection context menu gets first chance to dismiss on Escape; it must not also close the reader on that same keypress. Focused reader controls must still allow back navigation when they do not consume Escape.
- Honour the OS-configured back gesture when the OS delivers it to Flood. Do not claim universal finger-count support or intercept gestures reserved by the desktop environment.
- One completed back gesture causes at most one route pop. A cancelled gesture, forward gesture, ordinary scrolling, mouse drag, selection, pinch, or rotation does not navigate.
- Preserve the mounted timeline, feed/scope filter, existing list position, and stored read/saved state. In Unread, opening an article already removes it through markRead; preserve the resulting list context rather than reinserting it.
- Keep the visible Back button and existing mobile navigation.

## Implementation sequence

### 1. Verify desktop event delivery before choosing gesture handling
- Use a temporary event probe on real macOS, Windows, and Linux builds to record only input kind, direction, phases, and navigation commands; remove it after the investigation.
- Exercise default, changed, and disabled OS page-back gestures, plus natural-scroll settings. Inspect the actual SDK embedder paths and runner event propagation.
- macOS: evaluate a small FlutterViewController subclass in the runner for AppKit swipe events and fluid swipe tracking from scroll events. Respect the system swipe-tracking preference, cancellation, and native direction semantics. The installed Flutter controller currently ignores swipeWithEvent, so Dart-only recognition must not be assumed sufficient.
- Windows: verify OS/driver delivery as a back key or application command; handle APPCOMMAND_BROWSER_BACKWARD through the runner only if Flutter does not already deliver it. Trackpad pan events alone do not establish configured back intent.
- Linux: verify back key/event delivery under the tested desktop session and compositor. System-reserved gestures cannot be handled by Flood; record concrete support and limitations. Do not add a global gesture daemon or attempt to read arbitrary desktop configuration.
- Select the smallest supported adapter for each platform. A Dart trackpad recognizer is appropriate only when the input and preference semantics can be established; do not substitute a blanket horizontal-scroll handler for configured OS navigation.

### 2. Add focused failing behaviour tests
- Add a dedicated reader navigation widget test suite using existing in-memory Drift fixtures and real timeline-to-reader navigation.
- For all three desktop platform targets, send Escape and assert that the timeline is visible and the reader is gone; cover focused buttons, loading, and error states.
- Test overlay dismissal before reader dismissal and no navigation from the timeline or mobile targets.
- Inject semantic back events at the platform adapter boundary and assert actual route behaviour, one pop per gesture, no stale subscription after disposal, and no navigation when the reader is covered.
- Assert feed/scope and list offset preservation with a multi-article fixture, and persistence of read/saved state. Account for the existing Unread-list update.
- If raw gesture recognition is needed, exercise accepted, short, cancelled, wrong-direction, vertical/diagonal, pinch, and repeated event sequences. Include horizontal rich-content scrolling arbitration rather than testing only recognizer internals.
- Run each focused test before implementation and confirm the intended failure.

### 3. Implement Escape and one shared reader back action
- Add a desktop-only Shortcuts/Actions binding with an appropriate route focus scope around the whole ArticlePage, outside StreamBuilder state branches.
- Use Navigator.maybePop through a shared reader back action; guard current-route status and in-flight pops. Let overlays consume input before the reader action.
- Leave database and feed logic unchanged. Preserve the existing pushed route and timeline instance.

### 4. Connect the verified native gesture paths
- Put platform event translation behind a small injectable interface under lib/core/navigation; the reader consumes semantic back requests, not native event details.
- Use Flutter platform channels and runner hooks only where needed; add no dependency without a demonstrated gap.
- Enable native tracking only while an eligible reader is current and the app window is active; clean up callbacks/subscriptions when it is covered or disposed.
- Coordinate native and Dart event delivery to prevent duplicate pops and prevent consuming unrelated scroll input. Respect horizontal content scrolling and selection, with route-level back only when inner content has not claimed the interaction.
- Return to green tests, then refactor shared handling without broad navigation rewrites.

### 5. Validate and document
- Run dart format lib test, flutter analyze, focused tests, then flutter test; inspect git diff --check and final scope.
- Build and manually verify each changed desktop runner on its OS with real trackpad hardware. Synthetic Dart events cannot verify OS preferences, native event forwarding, or driver behaviour.
- Check light/dark/white-reader appearances, narrow/wide windows, 640×480 minimum, enlarged text, loading/error/missing content, rich HTML/code, keyboard focus, selection menus, and appearance sheet.
- Verify configured/disabled gesture settings, cancellation, direction, vertical and horizontal scrolling, repeated input, focus loss, and return to a filtered/scrolled timeline.
- Update README with verified desktop navigation support and specific platform/session limitations. Report untested platforms explicitly; Escape-only delivery is a partial implementation of this request.

## Implementation decisions
- Escape maps to `DismissIntent`, with a desktop reader action so a focused selection toolbar or modal route can supply its nearer dismissal action first.
- Linux uses Flutter's trackpad pan recognizer. Windows accepts that gesture and the native `WM_APPCOMMAND` browser-back command. macOS uses AppKit's `swipe(with:)`, which Flutter's stock view controller currently ignores.
- Pan back is trackpad-only, rightward by at least 100 logical pixels, and horizontal-dominant. Pan recognizers allow nested content to win the gesture arena; mouse drags, short/leftward/vertical pans do not pop.
- A mounted ArticlePage handles native semantic back messages only while its route is current. Modal routes keep their own Escape dismissal action.

## Completion criteria
Escape works on all three desktop targets; available OS-configured back gestures work through verified delivery paths; overlays and content scrolling retain expected behaviour; navigation preserves list and stored reader context; automated checks pass and native verification gaps are reported.

## Current outcome
Implementation and automated coverage are in place. The Linux runner builds and automated checks pass. The native macOS/Windows changes and physical trackpad behavior remain unverified because this session only has a Linux host.

## Scope
No forward history, custom gesture preferences, persistence migration, split-view redesign, or changes to mobile gestures.
