// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

extension SettingsDictionary {
    static var base: SettingsDictionary = [
        "LOCALIZED_STRING_MACRO_NAMES": [
            "NSLocalizedString",
            "CFCopyLocalizedString",
            "LocalizedString",
            "LocalizedStringInterpolation",
        ],
        "LOCALIZED_STRING_SWIFTUI_SUPPORT": "NO",
    ]

    static func extendingBase(with settings: SettingsDictionary) -> SettingsDictionary {
        self.base.merging(settings) { _, new in new }
    }
}
