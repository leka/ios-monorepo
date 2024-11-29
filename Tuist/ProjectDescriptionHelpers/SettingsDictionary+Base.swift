// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public extension SettingsDictionary {
    static var base: SettingsDictionary {
        var settings: SettingsDictionary = [
            "DEVELOPMENT_TEAM": "GKQJXACKX7",
            "LOCALIZED_STRING_MACRO_NAMES": [
                "NSLocalizedString",
                "CFCopyLocalizedString",
                "LocalizedString",
                "LocalizedStringInterpolation",
            ],
            "LOCALIZED_STRING_SWIFTUI_SUPPORT": "NO",
            "OTHER_LDFLAGS": [
                "-ObjC",
            ],
        ]

        settings = settings.betaFeature_enableExplicitModules(true)

        if Environment.developerMode.getBoolean(default: true) {
            settings = settings.otherSwiftFlags(["-D", "DEVELOPER_MODE"])
        }

        if Environment.testflightBuild.getBoolean(default: false) {
            settings = settings.otherSwiftFlags(["-D", "TESTFLIGHT_BUILD"])
        }

        if Environment.productionBuild.getBoolean(default: false) {
            settings = settings.otherSwiftFlags(["-D", "PRODUCTION_BUILD"])
        }

        return settings
    }

    static var manualCodeSigning: SettingsDictionary {
        var settings: SettingsDictionary = [:]

        if Environment.fastlaneBuild.getBoolean(default: false) {
            let bundleId = Environment.fastlaneMatchAppBundleId.getString(default: "")

            guard bundleId != "" else {
                fatalError("You must provide a certificate app name")
            }

            print("🔐 Using Fastlane match for code signing for bundle id: \(bundleId)")

            settings = settings.manualCodeSigning(identity: "Apple Distribution", provisioningProfileSpecifier: "match AppStore \(bundleId)")
        } else {
            settings = settings.manualCodeSigning(provisioningProfileSpecifier: "match Development io.leka.apf.*")
        }

        return settings
    }

    static func extendingBase(with settings: SettingsDictionary) -> SettingsDictionary {
        self.base.merging(settings) { _, new in new }
    }
}
