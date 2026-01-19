# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## Build Commands

```bash
# Initial setup
brew upgrade && brew install ruby node mise pre-commit gh git-lfs
git lfs install
mise install
bundle install
pre-commit install

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

## Tuist Environment Variables

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

## Architecture

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

### Deployment
- iOS 17.4+ minimum
- Destinations: iPad, Mac (Catalyst via iPad design)

## Code Style

- **SwiftFormat** and **SwiftLint** enforced via build phases
- Required file header: `Leka - iOS Monorepo\nCopyright APF France handicap\nSPDX-License-Identifier: Apache-2.0`
- Trailing commas required
- 4-space indentation
- `self.` is inserted (not removed)

## Fastlane

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

## Encrypted Files

Some files are encrypted with git-crypt:
```bash
brew install git-crypt
git-crypt unlock
```
