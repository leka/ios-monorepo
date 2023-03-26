# Leka iOS' Monorepo

[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=alert_status&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=code_smells&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=security_rating&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=sqale_rating&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo) [![Bugs](https://sonarcloud.io/api/project_badges/measure?project=leka_ios-monorepo&metric=bugs&token=ae37dc9610e171e3c40c43642f1697e2e5f05db4)](https://sonarcloud.io/summary/new_code?id=leka_ios-monorepo)

## About

This monorepo contains everything iOS/iPadOS related.

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

## License

Copyright (c) APF France handicap. All rights reserved.
