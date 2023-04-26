# Leka iOS' Monorepo

[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=alert_status&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=code_smells&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=security_rating&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=sqale_rating&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Bugs](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=bugs&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo)

## About

This monorepo contains everything iOS/iPadOS/macOS related, including:

- iPadOS apps available on the App Store
- iPadOS tools available only for internal use
- macOS apps and tools available only for internal use

## How to

To use the repo, simply do the following:

```bash
# clone repo
git clone https://github.com/leka/ios-monorepo && cd ios-monorepo

# install tuist (https://github.com/tuist/tuist)
curl -Ls https://install.tuist.io | bash

# install latest version if needed
tuist update

# install needed tools
brew upgrade && brew install fastlane swiftlint swift-format

# sync provisioning profiles and certificates
fastlane sync_certificates

# pull dependencies
tuist fetch

# generate all projects
tuist generate

# generate specific target/project
tuist generate LekaApp

# edit project config
tuist edit
```

See tuist documentation: <https://docs.tuist.io/tutorial/get-started>

## `TUIST_*` generation option

Tuist allows for "generation-time configuration" (see documentation for more information: https://docs.tuist.io/guides/environment).

We are leveraging the feature with different options:

- `TUIST_TURN_OFF_LINTERS` - turns off SwiftLint and swift-format, useful for CI or rapid development
- `TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG` - generates modules as frameworks (instead of static libraries), allowing developers to use more Xcode features such as Canvas to preview SwiftUI Views
- `TUIST_GENERATE_MAC_OS_APPS` - generates only available macOS applications

Example command:

```bash
TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=TRUE \
TUIST_GENERATE_MAC_OS_APPS=TRUE \
tuist generate
```

## Example projects

Different examples apps/tools (iOS, macOS, cli, module) are available as reference.

For more information, see [`Examples`](./Examples/) directory.

## License

Copyright (c) APF France handicap. All rights reserved.
