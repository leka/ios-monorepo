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


# install needed tools
brew upgrade && brew install ruby node mise pre-commit gh git-lfs
git lfs install
mise install
bundle install
pre-commit install
npm install --global git-json-merge
git config merge.json.driver \"git-json-merge %A %O %B\"
git config merge.json.name \"custom merge driver for json files\"

# sync provisioning profiles and certificates
bundle exec fastlane sync_certificates

# pull dependencies
make fetch

# generate all projects
make config

# edit project config
tuist edit
```

You can also use the default `tuist` commands. See tuist documentation: <https://docs.tuist.io/tutorial/get-started>

## `TUIST_*` generation option

Tuist allows for "generation-time configuration" (see documentation for more information: <https://docs.tuist.io/guides/environment>).

We are leveraging the feature with different options:

- `TUIST_TURN_OFF_LINTERS` - turns off SwiftLint and swift-format, useful for CI or rapid development
- `TUIST_GENERATE_EXAMPLE_TARGETS` - generate module example targets
- `TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG` - generates modules as frameworks (instead of static libraries), allowing developers to use more Xcode features such as Canvas to preview SwiftUI Views

Example command:

```bash
TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=TRUE \
TUIST_TURN_OFF_LINTERS=TRUE \
tuist generate
```

## Edit encrypted files

For security reasons, some files are encrypted. To be able to access and edit them, follow those steps:

```shell
# install git-crypt
brew install git-crypt

# unlock files
git-crypt unlock
```

More information here: https://github.com/AGWA/git-crypt#using-git-crypt

## License

Copyright (c) APF France handicap. All rights reserved.
