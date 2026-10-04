# iPhone Duo support plan

## Objective

Make Beer Mais usable across iPhone Duo's available window sizes and size transitions, while preserving existing iPhone behavior and iOS 17 support. Deliver compatibility fixes first, followed by optional improvements for wider layouts.

## Verified baseline

- Xcode 27.1 (27A9269) and the iOS 27.1 iPhone Duo simulator are installed.
- A simulator build targeting Duo succeeded during the September 18, 2026 review.
- The Duo simulator profile declares iPhone device family `1`, matching the app targets. There is no identified need to enable iPad support or raise the minimum deployment target.
- Runtime validation is pending: simulator boot reported a migration failure, and subsequent install/launch commands stalled.
- The findings below identify code risks; visual defects during Duo transitions have not yet been reproduced.

## Phase 1 — Establish a repeatable validation baseline

1. Use `DEVELOPER_DIR=/Applications/Xcode.27.1.app/Contents/Developer` for build and simulator commands, or select this Xcode installation in the developer environment.
2. Correct the BeerMais Dev scheme so all actions reference the existing BeerMais target in Debug; the old Dev target references are stale. Verify the StoreKit configuration reference resolves to an existing file.
3. Diagnose the Duo simulator startup/install issue. Preserve existing simulator data; use a separate test simulator if a clean environment is needed.
4. Build and launch the main app and App Clip, and install the widget. Record the simulator's actual available display configurations, orientations, window dimensions, and size classes.
5. Capture baseline screenshots of Home, create/edit, delete confirmation, About/donations, and the widget in each supported configuration.

Acceptance: a repeatable build/install/launch procedure works, and the tested Duo configurations are documented. Confirm actual platform behavior before introducing any Duo-specific settings or APIs.

## Phase 2 — Fix the app's root presentation

Files: `BeerMais/Config/SceneDelegate.swift`, `BeerMais/Scenes/Launch/LaunchScreenViewController.swift`.

1. Keep the launch animation, then replace the window's root controller with the `UIHostingController` containing `MainView`.
2. Preserve the existing dependency container, debug seeding, and widget refresh behavior.
3. Remove presentation configuration and dismissal prevention that only exist because the app is currently presented as a modal.
4. Verify the launch completion executes once and does not retain the launch controller unnecessarily.

Acceptance: the main interface fills its window, has no enclosing launch sheet, and remains usable through size changes and background/foreground transitions. App Clip root behavior remains consistent.

## Phase 3 — Make ads and donation cards follow container size

Files: `BeerMais/Views/BeerDetail/BeerDetailView.swift`, `BeerMais/Views/DeleteAll/DeleteAllView.swift`, `BeerMais/Common/BannerViewContainer.swift`, `BeerMais/Views/About/Donate/DonateView.swift`.

1. Measure the banner's actual available content width, accounting for Form insets and safe areas, instead of using `UIScreen.main.bounds` or a fixed screen-width subtraction.
2. Recalculate adaptive ad size when the effective width changes. Follow the installed Google Mobile Ads SDK's supported resizing/reload lifecycle.
3. Implement `updateUIView` to apply a changed size. Avoid repeated ad requests when the measured width is unchanged or temporarily zero.
4. Replace the deprecated orientation-based banner sizing API in the delete screen.
5. Size donation cards and images from their containing layout, with sensible limits. Allow wrapping or a vertical arrangement when three cards cannot fit.

Acceptance: banners and donation cards fit without horizontal overflow in sheets and resized windows; banner height matches its current ad size; normal SwiftUI updates do not trigger repeated loads. Use test ads for validation.

## Phase 4 — Adapt sheets and vertically constrained screens

Files: `BeerMais/Views/Home/HomeView.swift`, `BeerMais/Views/BeerDetail/BeerDetailView.swift`, `BeerMais/Views/DeleteAll/DeleteAllView.swift`, `BeerMais/Views/About/AboutView.swift`.

1. Replace the fixed 79% create/edit presentation with detents that permit expansion, selected according to observed available space and keyboard behavior.
2. Make delete confirmation content scroll or expand when necessary; keep the destructive action and cancel control reachable.
3. Make About content scrollable, including donations and version information.
4. Preserve the active tab, selected beer, unsaved form values, and presentation state when the window changes size. Avoid recreating feature view models based on layout branches.

Acceptance: every field and action remains reachable with the keyboard visible and at accessibility text sizes. Size changes neither dismiss an edit unexpectedly nor lose its contents. Successful mutations still refresh Home and widget data.

## Phase 5 — Improve adaptive cards and accessibility

Files: `BeerMais/Views/Home/HomeView.swift`, `BeerMais/Views/Beer/BeerView.swift`, donation views.

1. Replace the fixed two-column grid with an adaptive grid based on a tested minimum card width. Permit one column when text size or available width requires it.
2. Replace rigid 120-point card heights and 20-point text limits with content-driven sizing and suitable minimum heights.
3. Adopt semantic or scalable fonts. Support long brands, localized currency, and all existing localizations.
4. Give selectable beer cards accessible button semantics and meaningful VoiceOver labels.

Acceptance: no essential beer information is clipped, reading order is clear, and create/edit/delete controls remain discoverable. Verify both ordinary and accessibility text sizes on Duo and a conventional iPhone.

## Phase 6 — Optional enhancements

Implement these independently after the compatibility baseline is validated.

- **Wide comparison layout:** position the best-value summary alongside the beer list when container width supports it. Retain the compact layout and shared state.
- **Landscape:** evaluate enabling left/right landscape in both Dev and Prod iPhone orientation declarations. Ship only after validating all screens and the App Clip; portrait-only support has not been established as an installation blocker.
- **Medium widget:** add a useful comparison layout and update the provider's small-family-only logic, snapshot data if needed, and empty states. Keep the small widget supported.
- **Scene-aware donation feedback:** attach loading/success overlays and ad presentation to the initiating scene. Replace fixed overlay frames with constraints or SwiftUI layout so they follow resizing.

Acceptance: each enhancement has an explicit compact fallback and passes the relevant checks below. These features do not block the initial Duo compatibility release unless runtime testing reveals a functional defect that requires them.

## Validation and release criteria

Test the actual Duo configurations discovered in Phase 1, transitions between them, and one conventional iPhone. Include the oldest supported iOS version when an appropriate runtime or device is available; record any coverage gaps.

| Area | Checks |
| --- | --- |
| Launch and lifecycle | Cold launch, repeated launch, background/foreground, size changes during launch |
| Home | Empty, one-beer, and many-beer states; ordering; long names; scrolling; refresh |
| Editing | Create/edit/delete; keyboard visible; unsaved draft preserved during transitions; persistence failure keeps the form open |
| Delete all | Cancel, confirm, failure state, constrained height, ad loading/failure |
| About and donations | All content reachable; product loading; purchase success/cancel/failure; feedback during resizing |
| Accessibility and appearance | Dynamic Type, VoiceOver, light/dark appearance, English, Portuguese, Spanish |
| App Clip and widget | Shared layouts, separate Clip persistence, main-app widget refresh, small widget rendering |

Run existing domain and view-model tests after functional changes. Add targeted regression tests where they protect meaningful behavior, especially draft/state preservation; use representative UI or snapshot coverage for sizing rather than testing layout constants. Capture before/after screenshots at agreed sizes.

Release gate: all critical flows pass on Duo and the conventional iPhone; there is no clipped essential content, lost draft state, incorrect banner sizing, or unintended modal root. Main app, App Clip, and widget builds pass. Document any remaining simulator-only limitations before declaring device readiness.

## Suggested change sets

1. Development scheme correction and reproducible Duo validation notes.
2. Root presentation correction.
3. Container-aware ads and donation layout.
4. Adaptive sheets, scrolling, and state-preservation regressions.
5. Adaptive beer cards and accessibility.
6. Separate optional changes for wide comparison, landscape, medium widget, and scene-aware feedback.

Keep each change reviewable and validate it before proceeding to dependent work. The first release should prioritize Phases 1–4 and any clipping/accessibility issues confirmed during testing; optional features can follow.


## Implementation status — September 18, 2026

Implemented:

- Corrected all stale app-target references in the Dev scheme. The existing StoreKit configuration path resolves correctly.
- Replaced modal app presentation with a root-controller transition and a one-shot launch completion.
- Added debounced container-width banner measurement and SDK size updates without duplicate explicit ad loads.
- Made donations adaptive, About/delete content scrollable, and create/edit sheets large. Delete confirmation can expand from medium to large.
- Added scene-local keyboard dismissal and an accessible size menu to the editor.
- Added a width-driven Home grid and a side-by-side summary at wide widths using `AnyLayout`, preserving view identity.
- Replaced fixed beer-card heights/text limits with content-driven, scalable layouts and accessible edit buttons.
- Replaced global-window donation feedback with local progress/success presentation; rewarded ads use the initiating window through a weak reference.
- Added an accessibility-sizing regression and explicit BasicsKit imports required by existing test helpers.

Validation:

- Xcode 27.1 Duo-targeted build succeeded for the app and its embedded App Clip/widget.
- The test suite passed on iPhone 18 Pro / iOS 27.0: 46 tests, zero failures (including the new sizing regression).
- `git diff --check` passed.
- Duo reported display framebuffers of 2007 × 2853 and 1398 × 2034 pixels. These are simulator-reported pixel dimensions, not verified app window sizes or size classes.
- Both the original Duo simulator and a separate `Beer Mais Duo validation` simulator encountered startup/migration problems. The separate simulator was shut down without erasing data.
- App installation on the conventional simulator also timed out after 25 seconds. A passing hostless test suite does not establish successful application installation or UI operation.
- Device Hub was unavailable to computer-use tooling. No before/after UI screenshots, actual display transitions, StoreKit flows, or VoiceOver walkthroughs were completed.
- Draft-resize UI automation requires a hosted UI test environment; an attempted hostless text-field test was removed because it could not instantiate accessible form fields. Draft preservation remains a manual release check.
- No iOS 17 runtime validation was performed.

Deferred optional work:

- Landscape orientation enablement remains gated on successful screen/App Clip validation.
- Medium widget remains a separate enhancement after the compatibility baseline passes runtime validation; the existing small widget is unchanged.

The code is implemented and build/test validated, but the runtime release gate above is still open. Do not treat this as full Duo device certification.

### Reproduce validation

Use the installed Xcode explicitly without changing the machine-wide developer selection:

```sh
export DEVELOPER_DIR=/Applications/Xcode.27.1.app/Contents/Developer
xcrun simctl list devices available
xcodebuild -project BeerMais.xcodeproj -scheme 'BeerMais Dev' \
  -destination 'platform=iOS Simulator,name=iPhone Duo' \
  -derivedDataPath /tmp/beermais-duo-derived CODE_SIGNING_ALLOWED=NO build
xcodebuild -project BeerMais.xcodeproj -scheme 'BeerMais Dev' \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  -derivedDataPath /tmp/beermais-duo-derived -parallel-testing-enabled NO \
  CODE_SIGNING_ALLOWED=NO test
```

Use a simulator UUID instead of a name if duplicate devices exist. The development app bundle identifier is `br.com.joseneves.BeerMais.debug`.
