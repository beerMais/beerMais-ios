# Xcode project format

`BeerMais.xcodeproj/project.xcproj` is the source of truth for the project configuration. The outer `.xcodeproj` folder, shared schemes, workspace, and package lockfile retain their existing paths.

Xcode 27 or later is required to read this format. Xcode 27.2's native converter performed the migration:

```sh
xcodebuild -project BeerMais.xcodeproj -convert-project 'Xcode Project'
```

This is Xcode's JSON dialect; its generated trailing commas are intentional. Let Xcode read and write it rather than normalizing it with a strict JSON serializer.

Before and after migration, Xcode reported identical targets, schemes, configurations, and all effective Release build settings. Application version, dependencies, signing, resources, and data schema are unchanged.

The converted project passed a Release build for generic iOS with Xcode 27.2, two build jobs, and signing disabled. This compiled the app and embedded targets without starting a simulator. Log: `/tmp/beermais-json-release-build.log`. Existing plist-copy script warnings remain. Workflow YAML parses and `git diff --check` passes; the hosted CI/runtime-download path has not been executed locally. The earlier 88-test run predates this format-only migration.

CI uses the official `xcode-27` runner with Xcode 27.1, the stable installed version documented by the runner image at migration time. The image's Xcode 27.2 installation was still an RC. Xcode 27.1 supports the JSON format. CI installs the iOS 26.2 arm64 runtime and creates the reference iPhone 17 Pro to preserve the PNG comparison runtime. This adds a runtime download to CI startup. Local validation uses Xcode 27.2 (27B52).

## Rollback

Revert the migration commit, including its CI change, to restore the previous `project.pbxproj` and Xcode 26.3 workflow. Do not keep both project configuration files: that would leave two competing sources of truth. For a future configuration containing newer edits, use Xcode's Project Format setting or its native converter to export a legacy format instead of restoring an outdated project file.

The already uploaded 3.1.3 (50) binary and published release tag are unchanged by this repository-only migration.

References: [Apple migration guide](https://developer.apple.com/documentation/xcode/updating-your-xcode-project-configuration-file-format), [official runner labels](https://github.com/actions/runner-images), [Xcode 27 runner image](https://github.com/actions/runner-images/blob/main/images/macos/xcode-27-arm64-Readme.md).
