# Beer Mais release process

## Standing authorization rules

Prepare and save App Store drafts; do not click Add for Review or Submit for Review for the public App Store unless separately authorized. Never publish a new version or enable automatic public release. Ask José to perform public release himself. TestFlight beta review is a separate action and requires TestFlight authorization. Never treat TestFlight approval as public release approval.

## Prepare the candidate

1. Read repository instructions and protect unfinished local work. Review the intended diff and record scope in `Release/<version>.md`.
2. Set marketing version and a new build number consistently for main app, widget, and App Clip. Check remote build numbers when permissions permit; do not claim remote uniqueness without evidence.
3. Run relevant regression tests and Debug/Release builds. Check localization parity, whitespace, and any appropriate device accessibility checks. Record omissions honestly.
4. Archive the BeerMais scheme for generic iOS with Release configuration and signing. Use an existing healthy DerivedData package cache if a temporary cache lacks checkouts. Keep the archive/log paths in the release record.
5. Inspect packaged Info.plist versions for the app, widget, and App Clip. Verify the archive with `codesign --verify --deep --strict`; certificate trust verification may require system trust-store access.
6. Export with Xcode app-store-connect method, automatic signing, destination upload, team `2LEA6X25G9`, symbol upload enabled, and automatic version/build management disabled. Wait for explicit upload success, then Apple processing. An upload does not establish tester or public availability. Record SDK dSYM warnings separately.

## TestFlight, when authorized

1. Use the user's signed-in Brave Browser through supported UI tools. App id: `1450659497`; bundle id: `br.com.joseneves.BeerMais.ios`.
2. Open TestFlight and the processed build. Save What to Test instructions describing actual changes and acceptance checks.
3. Resolve Missing Compliance using answers explicitly verified by the user. Do not infer legal declarations or reuse historical answers blindly. For 3.1.1 (48), José selected Standard encryption and answered No to distribution in France. These are historical answers, not defaults for future builds; revisit encryption, SDKs, and distribution scope.
4. Add existing intended tester groups. Current groups are App Store Connect Users (internal) and Amigos (external). Verify membership/access shown by Apple. Do not invent testers or broaden access beyond the authorized testing scope.
5. External testing may require a beta description and beta review. Check the sign-in requirement against the app. Review automatic tester notification with the intended distribution scope. Submit only for TestFlight beta review when authorized.
6. Verify submitted state (for example Remove from Review), group attachment, and later availability. Distinguish waiting for beta review from available to external testers. Capture proof.

## Save the public App Store draft

1. Under Distribution, create the requested version if absent. Reuse an existing draft; do not create duplicates.
2. Save What's New for Portuguese (Brazil), English (U.S.), and Spanish (Mexico). Preserve approved descriptions, keywords, support URLs, screenshots, app privacy, ratings, pricing, and distribution unless a change is required and authorized.
3. Check inherited screenshot assets across localizations and supported device sizes. Optional headers/promotional text need not be invented. Evaluate whether new UI actually requires updated screenshots.
4. Attach the correct processed build. If App Clip metadata needs Apply, preserve existing metadata, save, and recheck the build association afterward; applying metadata can temporarily clear the displayed selection.
5. Save accurate reviewer steps, existing contact details, and sign-in requirement. For Beer Mais no account is currently required. Use the App Clip demo URL supplied by Apple in the reviewer App Clip URLs field when applicable.
6. Select Manually release this version. Keep existing rating. Save and verify saved values. Do not use Add for Review as a validation shortcut: it changes submission state.
7. Capture proof showing the draft/version/build and manual release setting. Record remaining checks; a saved draft is not a guarantee that Apple's final submission validation will pass.
8. Stop at Prepare for Submission. José performs public review submission and public launch. Never change live pricing, France availability, privacy declarations, or other live settings merely to match a questionnaire answer.

## Record results

Update `Release/<version>.md` and the persistent backlog with candidate version/build, validation, upload, compliance answers and their authorization, tester groups, beta review state, public draft state, screenshots/log paths, and unresolved checks. Keep TestFlight and public statuses separate. Never claim growth improvement or confirmed analytics delivery from release preparation alone.


## Version-specific exception: 3.1.1

On 2026-10-10 José explicitly authorized public review submission with automatic release for validated 3.1.1 (48). Save and verify the requested release mode before Add for Review, inspect the final submission contains only the intended version/build, submit, and verify Apple's explicit success confirmation. Apple confirmed “1 Item Submitted” for submission `9d69e477-a641-46d3-9ceb-cfe84e11267f`. This exception does not authorize future public submissions or automatic releases.
