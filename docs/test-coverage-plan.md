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

From the repository, run `./scripts/run-tests.sh` for the full suite on
`iPhone 18 Pro`, or pass another simulator name/UUID. The script uses the selected
Xcode, enables coverage, saves a unique result bundle and log, and prints coverage
after successful tests. Run `./scripts/run-tests.sh --help` for overrides.

## Automatic regression gate

`.github/workflows/tests.yml` runs the complete suite on every push and pull
request, and supports manual runs. It builds the app, App Clip, widget, and tests
with Xcode 26.3 on `macos-15`, then runs on the iPhone 17 Pro simulator. Test
failures fail the job. The committed `Package.resolved` pins direct and transitive
dependencies; the runner rejects missing or incompatible resolution instead of
silently choosing new package versions. Logs and `.xcresult` bundles are retained for 14 days,
including failed runs; superseded runs are cancelled and jobs time out after
45 minutes.

CI creates an inert Firebase plist only when the ignored development resource
is missing. It neither requires production credentials nor changes existing
developer configuration. The test bundle is hostless, so the app launch path
does not run. The suite covers domain, persistence, widget, presentation state,
and text contracts; it does not guarantee visual layout or live service behavior.

To enforce this gate before merging, require **Full test suite** in the repository
branch protection/ruleset. Adding a workflow alone does not enforce merge rules.
Add regression tests for new behavior to the existing test target; the workflow
runs the entire target without a test allowlist. For a CI-style artifact location
locally, set `BEERMAIS_TEST_RESULTS_DIR` to a directory before running the script.

## Detailed measurement

Use Xcode with the project's required SDK, resolve Swift packages, and supply the
local app configuration in `BeerMais/Property lists`. List available simulators with
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

## Validation

The original implementation received static validation only. Run the macOS
command above to validate the committed snapshots and measure coverage; retain
the result bundle and record the simulator, SDK, test count, and failures with
each measurement. A passing build alone does not establish passing tests.

### PR #10 review — 2026-10-12

The app, extensions, and test bundle compiled with Xcode 27.1 (iOS 27.1,
iPhone Duo) and Xcode 27.0 (iOS 27.0, iPhone 18 Pro), using `BeerMais Dev`,
coverage enabled, and serial test execution. Both simulator runs stalled before
any XCTest result and were interrupted after more than five minutes in the
runner. A sample of the 27.1 runner showed it loading the test bundle through
`dlopen` and Objective-C image registration, before test execution.

`git diff --check` passed. XCTest results, snapshot comparisons, and numerical
coverage remain unverified. App installation/launch was also attempted but did
not complete before the simulator commands were stopped. No before/after
coverage improvement is claimed. Existing concurrency warnings in `AppP.swift`
remain outside this test-only change.

### Successful simulator validation — 2026-10-12

The repaired iPhone 18 Pro simulator completed the original 81 tests with zero
failures, including all five text snapshots. The expanded suite completed 88
tests with zero failures on the same Xcode 27.0, scheme, and iOS 27.0 simulator.

| Coverage target | 81-test baseline | 88-test suite |
| --- | --- | --- |
| BeerWorker.swift in test bundle | 97.75% | 99.44% |
| BeerMais.app | 49.95% | 50.03% |
| BeerMaisTests.xctest | 65.99% | 67.65% |

The test-bundle total includes test code and duplicated app sources, so use the
per-file production-source report when choosing further tests. Seven new
regressions cover widget cleanup/idempotence, persistent package type/identity,
validation error priority, preview overflow recovery, custom presets, and the
real create/edit/delete-to-Home refresh path. No product code changed.
