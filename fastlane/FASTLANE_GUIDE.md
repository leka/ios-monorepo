# Leka iOS Fastlane Configuration Guide

This document provides a comprehensive overview of the Leka iOS fastlane setup, updated as part of the configuration review and improvement process.

## Overview

Fastlane automates the iOS app release process for the Leka project, handling:
- Certificate and provisioning profile management
- TestFlight beta releases  
- App Store production releases
- Changelog generation
- Build number management with commit tracking

## Build Number System

The Leka project uses a unique build number system that embeds commit information:

**Format**: `MAJOR.COMMIT_SHA_DECIMAL`
- **MAJOR**: Sequential number incremented for each build
- **COMMIT_SHA_DECIMAL**: First 10 hex characters of commit SHA converted to decimal

**Benefits**:
- Every build can be traced to its exact commit
- Enables rollbacks and debugging by commit reference
- Maintains App Store build number requirements

**Example**:
- Commit: `a1b2c3d4e5f6789...`
- Build number: `123.694488913125`

## Available Lanes

### Testing & Utilities

#### `helloworld`
Basic connectivity test to verify fastlane configuration.
```bash
bundle exec fastlane helloworld
```

#### Build Number Utilities
```bash
# Convert commit SHA to decimal
bundle exec fastlane commit_sha_to_decimal long_hash:abc123...

# Convert build number back to commit SHA  
bundle exec fastlane build_number_to_commit_sha build_number:123.456789

# Generate new build number for current commit
bundle exec fastlane create_new_build_number latest_build_number:122.123456
```

### Certificate Management

#### `sync_certificates`
Downloads existing certificates without creating new ones.
```bash
# Development certificates only
bundle exec fastlane sync_certificates

# Include App Store certificates
bundle exec fastlane sync_certificates release:true
```

#### `create_certificates`
Creates new certificates (use with caution).
```bash
# Development certificates only
bundle exec fastlane create_certificates

# Include App Store certificates  
bundle exec fastlane create_certificates release:true
```

### Release Management

#### `beta_internal`
Builds and uploads beta versions to TestFlight for internal testing.

**Features**:
- Builds apps with beta configuration
- Uses `.beta` bundle ID suffix
- Generates comprehensive changelogs
- Uploads to TestFlight with automatic distribution to LekaTeam group

```bash
# Single app
bundle exec fastlane beta_internal targets:LekaApp

# Multiple apps
bundle exec fastlane beta_internal targets:LekaApp,LekaUpdater

# All apps
bundle exec fastlane beta_internal targets:all
```

#### `release`
Builds and submits production versions to the App Store.

**Features**:
- Uses production bundle IDs (no `.beta` suffix)
- Separate API credentials for enhanced security
- Includes metadata and screenshot uploads
- Submits directly for App Store review
- Automatic release after approval

```bash
# Only one app can be released at a time
bundle exec fastlane release target:LekaApp
bundle exec fastlane release target:LekaUpdater
```

#### `generate_changelogs`
Creates formatted changelogs for TestFlight, GitHub, and Slack.

**Formats**:
- **TestFlight**: Plain text for app submission notes
- **GitHub**: Markdown for PR comments and releases  
- **Slack**: Slack-formatted with emojis for notifications

Called automatically by `beta_internal` and `release` lanes.

## Environment Variables

### Required for CI
```bash
# Keychain Management
FASTLANE_KEYCHAIN_PASSWORD=<keychain_password>

# Code Signing (Match)
MATCH_PASSWORD=<certificates_repo_password>
MATCH_GIT_BASIC_AUTHORIZATION=<basic_auth_token>

# App Store Connect API (Beta)
APP_STORE_CONNECT_API_KEY_ID=<beta_key_id>
APP_STORE_CONNECT_ISSUER_ID=<issuer_id>
APP_STORE_CONNECT_API_KEY_CONTENT=<beta_private_key>

# App Store Connect API (Release - separate for security)
APP_STORE_CONNECT_API_KEY_ID_RELEASE_APP_STORE=<release_key_id>
APP_STORE_CONNECT_API_KEY_CONTENT_RELEASE_APP_STORE=<release_private_key>
```

### Optional
```bash
# PR Information
PR_NUMBER=<pull_request_number>
BASE_REF=develop  # Default branch for changelog comparison

# Fastlane Configuration
FASTLANE_SKIP_UPDATE_CHECK=1  # Skip version check in CI
```

## GitHub Actions Integration

### Beta Releases
Triggered by:
- Push to `develop` branch (LekaApp only)
- PR labels: `fastlane:beta` + app name (`LekaApp`, `LekaUpdater`)

### Production Releases  
Triggered by:
- PR labels: `fastlane:deliver` + app name (`LekaApp`, `LekaUpdater`)

## Configuration Files

### `Appfile`
- Apple ID and team configuration
- Supports per-platform and per-lane overrides

### `Matchfile`
- Certificate repository configuration
- Git-based storage for encrypted certificates

### `Deliverfile`
- App Store submission defaults
- Language support and review configuration

## Security Best Practices

1. **Separate Credentials**: Beta and release use different API keys
2. **Encrypted Storage**: Certificates stored encrypted in private repo
3. **Temporary Keychains**: Created fresh for each build, cleaned up after
4. **Environment Validation**: Required variables checked before execution
5. **Access Control**: Certificate repo has restricted access

## Troubleshooting

### Common Issues

1. **Missing Environment Variables**
   - Check all required variables are set in CI
   - Validation will show specific missing variables

2. **Certificate Issues**
   - Run `sync_certificates` to refresh local certificates
   - Check certificate expiration dates
   - Verify bundle IDs match in certificates repo

3. **Build Number Conflicts**
   - Build numbers are automatically incremented
   - Manual override not recommended (breaks commit tracking)

4. **TestFlight Upload Failures**
   - Check API key permissions
   - Verify bundle ID is registered in App Store Connect
   - Ensure app version exists in App Store Connect

### Getting Help

1. Check fastlane logs for detailed error messages
2. Verify environment variables are correctly set
3. Test with `helloworld` lane to verify basic configuration
4. Check GitHub Actions logs for CI-specific issues

## Recent Improvements

- ✅ Fixed syntax errors and updated fastlane to v2.228.0
- ✅ Added comprehensive documentation (200+ lines)
- ✅ Extracted helper functions to reduce code duplication
- ✅ Improved validation and error handling
- ✅ Optimized configuration files
- ✅ Enhanced GitHub workflow configurations

This guide reflects the current state after the fastlane configuration review and improvements completed in 2025.