# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

#
# MARK: - Options
#

GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG ?= TRUE
TURN_OFF_LINTERS ?= FALSE
TEST_FLIGHT_APP_NAME ?= LekaApp


#
# MARK: - Build targets
#

fetch:
	@echo "Fetching dependencies..."
	@tuist install

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

sync_certificates:
	@echo "Syncing certificates..."
	@export FASTLANE_SKIP_UPDATE_CHECK=1
	@fastlane sync_certificates

lint:
	@echo "Linting code..."
	@-swiftlint --quiet --fix && swiftlint --quiet --progress
	@echo ""
	@-swiftformat --lint .

format:
	@echo "Formatting code..."
	@-swiftlint --quiet --fix
	@-swiftformat .
