# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

#
# MARK: - Options
#

TURN_OFF_LINTERS ?= FALSE
GENERATE_EXAMPLE_TARGETS ?= TRUE
GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG ?= TRUE
TEST_FLIGHT_APP_NAME ?= LekaApp


#
# MARK: - Build targets
#

fetch:
	@echo "Fetching dependencies..."
	@TUIST_TURN_OFF_LINTERS=$(TURN_OFF_LINTERS) 												\
	 TUIST_GENERATE_EXAMPLE_TARGETS=$(GENERATE_EXAMPLE_TARGETS) 								\
	 TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=$(GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG) \
	 tuist install

config:
	@echo "Generating project..."
	@TUIST_TURN_OFF_LINTERS=$(TURN_OFF_LINTERS) 												\
	 TUIST_GENERATE_EXAMPLE_TARGETS=$(GENERATE_EXAMPLE_TARGETS) 								\
	 TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=$(GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG) \
	 tuist generate --no-binary-cache

config_testflight:
	@echo "Generating project..."
	@TUIST_TURN_OFF_LINTERS=TRUE 																\
	 TUIST_GENERATE_EXAMPLE_TARGETS=FALSE 														\
	 TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=FALSE 										\
	 TUIST_DEVELOPER_MODE=TRUE 																	\
	 TUIST_TESTFLIGHT_BUILD=TRUE 																\
	 TUIST_PRODUCTION_BUILD=FALSE 																\
	 tuist generate --no-binary-cache

config_release:
	@echo "Generating project..."
	@TUIST_TURN_OFF_LINTERS=TRUE 																\
	 TUIST_GENERATE_EXAMPLE_TARGETS=FALSE 														\
	 TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=FALSE 										\
	 TUIST_DEVELOPER_MODE=FALSE																	\
	 TUIST_TESTFLIGHT_BUILD=FALSE 																\
	 TUIST_PRODUCTION_BUILD=TRUE 																\
	 tuist generate --no-binary-cache

build:
	@echo "Building project..."
	@TUIST_TURN_OFF_LINTERS=$(TURN_OFF_LINTERS) 												\
	 TUIST_GENERATE_EXAMPLE_TARGETS=$(GENERATE_EXAMPLE_TARGETS) 								\
	 TUIST_GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG=$(GENERATE_MODULES_AS_FRAMEWORKS_FOR_DEBUG) \
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
