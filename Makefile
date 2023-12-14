# Leka - iOS Monorepo
# Copyright 2023 APF France handicap
# SPDX-License-Identifier: Apache-2.0

#
# MARK: - Options
#

GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG ?= TRUE
TURN_OFF_LINTERS ?= FALSE
TEST_FLIGHT_APP_NAME ?= LekaActivityUIExplorer


#
# MARK: - Build targets
#

fetch:
	@echo "Fetching dependencies..."
	@tuist fetch

config:
	@echo "Generating project..."
	@TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=$(GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG) \
	 TUIST_TURN_OFF_LINTERS=$(TURN_OFF_LINTERS) 												\
	 tuist generate

build:
	@echo "Building project..."
	@TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=$(GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG) \
	 TUIST_TURN_OFF_LINTERS=$(TURN_OFF_LINTERS) 												\
	 tuist build

clean:
	@echo "Cleaning project..."
	@tuist clean
	@rm -rf .build
	@rm -rf ~/Library/Developer/Xcode/DerivedData
	@gfind . -type d -name "*.xcodeproj" -exec rm -rf {} +


#
# MARK: - Tools targets
#

setup:
	@echo "Setting up dev environment..."
	@brew update && brew upgrade
	@brew install swiftformat swiftlint fastlane
	@brew install tuist --no-quarantine

sync_certificates:
	@echo "Syncing certificates..."
	@export FASTLANE_SKIP_UPDATE_CHECK=1
	@fastlane sync_certificates

git_hooks:
	@echo "Installing pre-commit hooks..."
	@brew install pre-commit
	@pre-commit install

format:
	@echo "Formatting code..."
	@swiftlint --quiet --fix
	@swiftformat .

lint:
	@echo "Linting code..."
	@-swiftlint --quiet --fix && swiftlint --quiet --progress
	@echo ""
	@-swiftformat --lint .

ci_test_flight_release:
	@git checkout main
	@git pull
	@git checkout release/testflight-beta
	@git rebase main
	@git push --force-with-lease
	@gh pr edit --add-label "fastlane:rbi $(TEST_FLIGHT_APP_NAME)"
	@git checkout main
