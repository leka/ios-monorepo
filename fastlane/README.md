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

Test lane to verify fastlane configuration is working correctly

Usage: fastlane helloworld

This lane performs a basic connectivity test and displays configuration information

### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Synchronize certificates and provisioning profiles from the certificates repository

This lane downloads existing certificates without creating new ones

Options:

 - release: [Boolean] If true, also syncs App Store certificates (default: false)

Usage: fastlane sync_certificates release:true

Note: Requires MATCH_PASSWORD and MATCH_GIT_BASIC_AUTHORIZATION environment variables

### ios create_certificates

```sh
[bundle exec] fastlane ios create_certificates
```

Create new certificates and provisioning profiles

This lane generates new certificates when needed (e.g., for new devices)

Options:

 - release: [Boolean] If true, also creates App Store certificates (default: false)

Usage: fastlane create_certificates release:true

Note: Use with caution as this can invalidate existing certificates

### ios beta_internal

```sh
[bundle exec] fastlane ios beta_internal
```

Build and submit internal beta versions to TestFlight

This lane builds apps in beta configuration and uploads them to TestFlight for internal testing



Process Overview:

1. Validates target parameter and sets up build configuration

2. Generates Xcode project using Tuist with beta settings

3. Configures App Store Connect API authentication

4. Determines build number using commit SHA encoding system

5. Builds the app with App Store export method

6. Uploads to TestFlight with changelog

7. Cleans up temporary keychain



Build Number System:

Build numbers follow the format 'MAJOR.COMMIT_SHA_DECIMAL' where:

- MAJOR: Incremented for each build (starts from latest TestFlight build + 1)

- COMMIT_SHA_DECIMAL: First 10 hex chars of commit SHA converted to decimal

This allows tracking which commit each build came from



Options:

 - targets: [String] Comma-separated list of targets to build, or 'all' for all targets

           Available targets: LekaApp, LekaUpdater

           Example: 'LekaApp,LekaUpdater' or 'all'



Environment Variables Required:

 - APP_STORE_CONNECT_API_KEY_ID: API key ID for TestFlight uploads

 - APP_STORE_CONNECT_ISSUER_ID: Issuer ID for App Store Connect API

 - APP_STORE_CONNECT_API_KEY_CONTENT: Private key content for API

 - FASTLANE_KEYCHAIN_PASSWORD: Password for temporary keychain

 - MATCH_PASSWORD: Password for certificates repository

 - MATCH_GIT_BASIC_AUTHORIZATION: Auth token for certificates repo



Usage Examples:

 fastlane beta_internal targets:LekaApp

 fastlane beta_internal targets:LekaApp,LekaUpdater

 fastlane beta_internal targets:all



Note: This lane is typically triggered by GitHub Actions on PR labels or develop branch pushes

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and release production versions to the App Store

This lane builds apps in production configuration and submits them to App Store Connect



Process Overview:

1. Validates single target parameter (only one app can be released at a time)

2. Generates Xcode project using Tuist with production settings

3. Configures App Store Connect API with release-specific credentials

4. Determines build number and generates comprehensive changelog

5. Builds the app with App Store export method

6. Uploads to App Store Connect with metadata and screenshots

7. Submits for review with automatic release configuration

8. Cleans up temporary keychain



Key Differences from beta_internal:

- Uses production bundle IDs (without .beta suffix)

- Uses separate API credentials for enhanced security

- Includes metadata and screenshot uploads

- Submits directly for App Store review

- Configured for automatic release after approval



Options:

 - target: [String] Single target to release (required)

           Available targets: LekaApp, LekaUpdater

           Example: 'LekaApp' (only one target allowed)



Environment Variables Required:

 - APP_STORE_CONNECT_API_KEY_ID_RELEASE_APP_STORE: Separate API key for releases

 - APP_STORE_CONNECT_ISSUER_ID: Issuer ID for App Store Connect API

 - APP_STORE_CONNECT_API_KEY_CONTENT_RELEASE_APP_STORE: Release-specific private key

 - FASTLANE_KEYCHAIN_PASSWORD: Password for temporary keychain

 - MATCH_PASSWORD: Password for certificates repository

 - MATCH_GIT_BASIC_AUTHORIZATION: Auth token for certificates repo



Usage Examples:

 fastlane release target:LekaApp

 fastlane release target:LekaUpdater



Note: This lane is typically triggered by GitHub Actions on specific PR labels

      Only one app can be released at a time for better control and review

### ios generate_changelogs

```sh
[bundle exec] fastlane ios generate_changelogs
```

Generate changelogs for TestFlight, GitHub, and Slack notifications

This lane creates formatted changelogs by analyzing git commit history between builds



Changelog System Overview:

The system generates three different changelog formats:

1. TestFlight: Plain text for app submission notes (no emojis/markdown)

2. GitHub: Markdown formatted for PR comments and releases

3. Slack: Slack-formatted with emojis for team notifications



Git History Analysis:

- For PR builds: Compares HEAD commit to base branch (usually develop)

- For direct pushes: Compares to previous TestFlight build commit

- Uses git_log_to_notes.py script to format commit messages

- Handles edge cases like force pushes and missing commits



Options (all required):

 - release_type: [String] 'beta' or 'release' to determine formatting

 - target: [String] App name for display in changelog

 - version_number: [String] App version number

 - latest_build_number: [String] Previous build for comparison

 - new_build_number: [String] New build number

 - pr_number: [String] PR number or 'NO_PR' for direct pushes



Returns: TestFlight changelog text

Side Effects: In CI, writes all three changelog formats to GITHUB_ENV



Usage: This lane is called internally by beta_internal and release lanes

### ios commit_sha_to_decimal

```sh
[bundle exec] fastlane ios commit_sha_to_decimal
```

Convert commit SHA to decimal for build number encoding

Takes a full 40-character commit SHA and converts the first 10 hex characters

to decimal representation for use in build numbers.



Process:

1. Extract first 10 hex characters from commit SHA

2. Convert hex to decimal

3. Validate decimal fits within build number constraints

4. Verify round-trip conversion works correctly



Options:

 - long_hash: [String] Full 40-character commit SHA (required)



Returns: Decimal string representation of commit SHA

Example: commit_sha_to_decimal(long_hash: 'a1b2c3d4e5f6789...')

### ios build_number_to_commit_sha

```sh
[bundle exec] fastlane ios build_number_to_commit_sha
```

Convert decimal build number component back to commit SHA

Reverse operation of commit_sha_to_decimal - extracts commit SHA from build number



Process:

1. Parse decimal component from build number (after the dot)

2. Convert decimal back to hexadecimal

3. Pad with leading zeros to get 10-character hash

4. Validate result meets constraints



Options:

 - build_number: [String] Build number in format 'MAJOR.DECIMAL' (required)



Returns: 10-character hex string representing commit SHA prefix

Example: build_number_to_commit_sha(build_number: '123.694847286757')

### ios create_new_build_number

```sh
[bundle exec] fastlane ios create_new_build_number
```

Generate new build number for the current commit

Creates a new build number by incrementing the major version and encoding the current commit SHA



Process:

1. Parse latest build number to get major version

2. Increment major version by 1

3. Get current commit SHA from git

4. Convert commit SHA to decimal using commit_sha_to_decimal

5. Combine major version and decimal SHA: 'MAJOR.SHA_DECIMAL'

6. Validate final build number meets App Store constraints



Options:

 - latest_build_number: [String] Previous build number for increment base (required)



Returns: New build number string in format 'MAJOR.SHA_DECIMAL'

Example: create_new_build_number(latest_build_number: '122.694847286757')

         might return '123.845739204821' for current commit

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
