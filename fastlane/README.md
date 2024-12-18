fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios helloworld

```sh
[bundle exec] fastlane ios helloworld
```

Placeholder lane to make sure fastlane's working

### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Sync certificates

### ios create_certificates

```sh
[bundle exec] fastlane ios create_certificates
```

Create certificates

### ios beta_internal

```sh
[bundle exec] fastlane ios beta_internal
```

Submit new internal beta app

### ios release

```sh
[bundle exec] fastlane ios release
```

Release new app version to App Store Connect

### ios generate_changelogs

```sh
[bundle exec] fastlane ios generate_changelogs
```

Generate changelogs for TestFlight, Github and Slack

### ios commit_sha_to_decimal

```sh
[bundle exec] fastlane ios commit_sha_to_decimal
```

Convert commit hash to decimal representation of the first 11 hex characters

### ios build_number_to_commit_sha

```sh
[bundle exec] fastlane ios build_number_to_commit_sha
```

Convert decimal representation of the first 11 hex characters to commit hash

### ios create_new_build_number

```sh
[bundle exec] fastlane ios create_new_build_number
```

Create new build number

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
