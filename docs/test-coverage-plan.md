# Test coverage plan

## Baseline and priorities

Existing XCTest suites cover beer ranking, Core Data CRUD and rollback, widget
publication, editor validation, selected view-model behavior, adaptive layout,
and first-comparison analytics. SnapshotTesting 1.19.2 is already linked to the
test target, but no snapshot assertions were present at the start of this work.

Execute these independent work streams, then review and run the combined suite:

1. **Domain:** exercise ranking with different volumes, invalid-price/volume
   boundaries, BeerData type changes, and cents/display formatting boundaries.
2. **View models:** exercise empty/populated/repopulated Home states, replacing
   and clearing Beer card data, zero-value guards, and editor error recovery.
3. **Snapshots:** commit deterministic text baselines for user-facing formatting
   and presentation state. Pair snapshots with focused behavioral assertions.
4. **Integration:** register snapshot sources in the test target, enable coverage
   in both shared app schemes, and run all tests with coverage on macOS.

Do not set a percentage target until a measured baseline exists. Prioritize
uncovered decisions that can change persistence or user-visible output; review
per-file coverage before choosing the next additions.

## Run and measure (macOS)

Use Xcode with the project's required SDK, resolve Swift packages, and supply the
local app configuration described in the README. List available simulators with
`xcrun simctl list devices available`, then replace the destination below with a
compatible installed simulator. Use a fresh result-bundle path for every run.

```sh
xcodebuild test \
  -project BeerMais.xcodeproj \
  -scheme BeerMais \
  -destination 'platform=iOS Simulator,id=<SIMULATOR-UDID>' \
  -enableCodeCoverage YES \
  -resultBundlePath /tmp/BeerMais-coverage.xcresult

xcrun xccov view --report /tmp/BeerMais-coverage.xcresult
xcrun xccov view --report --json /tmp/BeerMais-coverage.xcresult > /tmp/BeerMais-coverage.json
```

Record the before/after line coverage for the same scheme, SDK, and destination.
The test target also compiles app sources directly: inspect coverage for both the
app and test bundle when interpreting the report. New test counts alone do not
establish a measured coverage increase.

## Snapshot review

Text snapshots protect display contracts without depending on simulator fonts or
screen scale. Review baseline diffs as product changes, and rerun in comparison
mode after recording an intentional change. Never enable recording by default.

For a later visual-snapshot pass, pin simulator model, OS, locale, color scheme,
and Dynamic Type size. Cover normal/highlighted cards and editor error states in
light/dark mode and accessibility text sizes. Record and inspect actual images
on that simulator before committing them; image baselines cannot be produced or
verified in a Linux environment.

## Validation limitation

This workspace runs Linux and provides neither Swift nor Xcode. Repository and
project consistency can be checked here, but XCTest execution, image rendering,
and numerical coverage measurement require the macOS run above.
