# Repository Guidelines

## Project Structure & Module Organization
- `Apps/` contains app targets like `LekaApp/` and `LekaUpdater/` with `Sources/`, `Resources/`, `Tests/`, and `Project.swift`.
- `Modules/` holds reusable kits (e.g., `AccountKit/`, `RobotKit/`) with `Sources/`, `Resources/`, `Tests/`, and optional `Examples/`.
- `Tuist/`, `Tuist.swift`, and `Workspace.swift` define the workspace; shared templates live in `Tuist/ProjectDescriptionHelpers/`.
- `fastlane/`, `Scripts/`, and `Tools/` contain automation; `Documentation/` and `Specs/` hold supporting docs and specs.

## Build, Test, and Development Commands
- `make fetch`: install Tuist dependencies using repo flags.
- `make config`: generate the Xcode project with Tuist (produces `ios-monorepo.xcworkspace`).
- `make build`: build via Tuist using the current flags.
- `make clean`: clean Tuist artifacts, `.build`, DerivedData, and generated `.xcodeproj` files.
- `make lint` / `make format`: run SwiftLint and SwiftFormat for linting and formatting.
- `make sync_certificates` or `bundle exec fastlane sync_certificates`: sync signing assets.
- `tuist edit`: edit Tuist configuration in a dedicated workspace.
- Tuist flags from `CLAUDE.md`: `TUIST_TURN_OFF_LINTERS`, `TUIST_GENERATE_EXAMPLE_TARGETS`, `TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG`, `TUIST_TESTFLIGHT_BUILD`, `TUIST_PRODUCTION_BUILD`, `TUIST_DEVELOPER_MODE`.
- Common fastlane lanes: `bundle exec fastlane beta_internal targets:LekaApp`, `bundle exec fastlane release target:LekaApp`.

## Coding Style & Naming Conventions
- SwiftLint and SwiftFormat define style; use `make lint`/`make format` before pushing.
- `CLAUDE.md` specifics: 4-space indentation, trailing commas required, and `self.` is inserted (not removed).
- Required file header: `Leka - iOS Monorepo` + copyright + `SPDX-License-Identifier: Apache-2.0`.
- Keep module and app code under `Sources/` and assets under `Resources/`.
- Tests live in `Tests/` and follow `*_Tests.swift` naming (e.g., `Modules/UtilsKit/Tests/Utils_Tests.swift`).

## Testing Guidelines
- Tests are standard XCTest targets per app/module in `Tests/`.
- After `make config`, run tests from Xcode (`Product > Test`) in `ios-monorepo.xcworkspace`.

## Commit & Pull Request Guidelines
- Commit messages follow the gitmoji convention with scope, e.g., `🚨 (tuist): Fix implicit dependencies`.
- Use clear scopes (`ci`, `tuist`, `fastlane`, module name) and concise verbs.
- PRs should include a short summary, linked issue (if any), test notes (e.g., `make lint`, Xcode tests), and screenshots for UI changes.
- Mention any non-default Tuist flags used (`TUIST_*`) when generating projects.

## Security & Configuration
- Some files are encrypted; unlock them with `git-crypt unlock` after installing `git-crypt`.
- Signing assets are managed via fastlane; ensure required env vars are set when running in CI.
## Platform & Deployment Notes
- Minimum iOS version is 17.4; destinations include iPad and Mac (Catalyst via iPad design).
