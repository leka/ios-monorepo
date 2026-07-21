# Repository Guidelines

This file is the single source of truth for AI coding agents working in this repository.
It is read by Claude Code, OpenCode, Codex, and other tools.

## Project Overview

Leka iOS monorepo containing iPadOS/macOS apps for a special needs education robot. The project uses **Tuist** for Xcode project generation.

**Apps:**
- `LekaApp` - Main consumer app (App Store)
- `LekaUpdater` - Robot firmware updater (internal)

**Modules (in `Modules/`):**
- `AccountKit` - User account management
- `AnalyticsKit` - Firebase analytics
- `BLEKit` - Bluetooth Low Energy communication (uses CombineCoreBluetooth)
- `ContentKit` - Educational content, activities, and curriculums
- `DesignKit` - UI components and design system
- `FirebaseKit` - Firebase integration
- `LocalizationKit` - Localization (l10n)
- `LogKit` - Logging (uses swift-log)
- `RobotKit` - Robot control (lights, motion, reinforcers, magic cards)
- `UtilsKit` - Shared utilities

## Project Structure & Module Organization

- `Apps/` contains app targets like `LekaApp/` and `LekaUpdater/` with `Sources/`, `Resources/`, `Tests/`, and `Project.swift`.
- `Modules/` holds reusable kits (e.g., `AccountKit/`, `RobotKit/`) with `Sources/`, `Resources/`, `Tests/`, and optional `Examples/`.
- `Tuist/`, `Tuist.swift`, and `Workspace.swift` define the workspace; shared templates live in `Tuist/ProjectDescriptionHelpers/`.
- `fastlane/`, `Scripts/`, and `Tools/` contain automation; `Documentation/` and `Specs/` hold supporting docs and specs.

### Tuist Structure

- `Tuist.swift` - Global Tuist config
- `Workspace.swift` - Workspace definition listing all projects
- `Tuist/Package.swift` - External SPM dependencies
- `Tuist/ProjectDescriptionHelpers/` - Shared project templates:
  - `Project+App.swift` - App target template
  - `Project+Module.swift` - Module/framework template
  - `TargetScripts.swift` - Build phase scripts (linters)

### Module Structure

Each module follows a consistent pattern:
```
Modules/<ModuleName>/
├── Project.swift      # Tuist project definition
├── Sources/           # Source files (buildable folder)
├── Resources/         # Bundle resources
├── Tests/             # Unit tests
└── Examples/          # Optional example app (if ModuleExample defined)
```

## Build, Test, and Development Commands

```bash
# Initial setup
brew upgrade && brew install ruby node mise gh git-lfs
git lfs install
mise install
bundle install
hk install --mise
npm install --global ajv-cli

# Sync certificates (required for code signing)
bundle exec fastlane sync_certificates

# Pull dependencies
make fetch

# Generate Xcode project (default: frameworks + linters + example targets)
make config

# Build
make build

# Clean everything
make clean

# Format code
make format

# Lint code
make lint

# Edit Tuist configuration
tuist edit
```

### Tuist Environment Variables

Control project generation via environment variables:

```bash
# Turn off SwiftLint (useful for CI or rapid iteration)
TUIST_TURN_OFF_LINTERS=TRUE tuist generate

# Generate without example targets
TUIST_GENERATE_EXAMPLE_TARGETS=FALSE tuist generate

# Generate as static libraries (default) instead of frameworks
TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=FALSE tuist generate

# Build configurations
TUIST_TESTFLIGHT_BUILD=TRUE   # Beta build
TUIST_PRODUCTION_BUILD=TRUE   # App Store release
TUIST_DEVELOPER_MODE=TRUE     # Developer features enabled
```

### Fastlane

```bash
# Sync certificates (read-only)
bundle exec fastlane sync_certificates

# Create new certificates
bundle exec fastlane create_certificates

# Beta build to TestFlight
bundle exec fastlane beta_internal targets:LekaApp

# App Store release
bundle exec fastlane release target:LekaApp
```

## Coding Style & Naming Conventions

- **SwiftFormat** and **SwiftLint** enforced via build phases; use `make lint`/`make format` before pushing.
- Required file header: `Leka - iOS Monorepo` + `Copyright APF France handicap` + `SPDX-License-Identifier: Apache-2.0`
- Trailing commas required
- 4-space indentation
- `self.` is inserted (not removed)
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

- Some files are encrypted with git-crypt; unlock them with `git-crypt unlock` after installing `git-crypt` (`brew install git-crypt`).
- Signing assets are managed via fastlane; ensure required env vars are set when running in CI.

## Platform & Deployment Notes

- Minimum iOS version is 17.4.
- Destinations include iPad and Mac (Catalyst via iPad design).
