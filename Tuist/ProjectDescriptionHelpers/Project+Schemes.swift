// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public enum SchemeList {
    public static func l10nFR(name: String) -> Scheme {
        Scheme(
            name: "\(name) 🇫🇷",
            shared: true,
            buildAction: BuildAction(targets: ["\(name)"]),
            runAction: RunAction.runAction(configuration: "Debug", options: .options(language: "fr"))
        )
    }

    public static func l10nEN(name: String) -> Scheme {
        Scheme(
            name: "\(name) 🇺🇸",
            shared: true,
            buildAction: BuildAction(targets: ["\(name)"]),
            runAction: RunAction.runAction(configuration: "Debug", options: .options(language: "en"))
        )
    }
}
