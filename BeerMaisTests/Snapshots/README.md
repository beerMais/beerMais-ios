# Presentation snapshots

`BeerPresentationSnapshotTests` uses the existing SnapshotTesting package's
`.lines` strategy. Five committed UTF-8 baselines protect visible volume labels,
currency and cents input, editor presets and custom volume previews, ranked card
updates, and highlighted card presentation. Snapshot payloads omit managed object
IDs and use explicit fixture values. Card tests use the real worker with a
repository spy, so changes to volume exercise rate calculation and formatting
without persistence or network calls.

These are text presentation snapshots, not rendered UI images. They do not
detect layout, clipping, typography, accessibility, or color regressions.
Image snapshots remain a follow-up; the committed baselines cover text only.

Run on macOS with Xcode and an available simulator:

```sh
xcodebuild test -project BeerMais.xcodeproj -scheme BeerMais \
  -destination 'platform=iOS Simulator,id=<SIMULATOR-UDID>' \
  -only-testing:BeerMaisTests/BeerPresentationSnapshotTests
```

Use `xcodebuild -list -project BeerMais.xcodeproj` and
`xcrun simctl list devices available` to choose the local scheme and device.
Baselines live beside the test source in
`__Snapshots__/BeerPresentationSnapshotTests`; they do not need target resource
membership. Only the Swift source requires test target membership.

For an intentional presentation change, change the affected assertion's
`record: false` to `record: true`, run that test on macOS, review the exact text
diff, then restore `record: false` and rerun. Keep automatic recording disabled
in CI. Do not accept newly generated references without reviewing their output.

For future visual snapshots, render the actual SwiftUI views with
`UIHostingController` and SnapshotTesting's `.image` strategy on a pinned iOS
runtime and simulator. Fix screen dimensions, locale, light/dark appearance and
Dynamic Type; inject workers that avoid ad and network side effects. Record and
review real PNG baselines on that simulator before enabling these tests in CI.
