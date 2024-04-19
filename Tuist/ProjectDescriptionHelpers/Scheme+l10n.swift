// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public extension Scheme {
    static func l10nFR(name: String) -> Scheme {
        Scheme(
            name: "\(name) 🇫🇷",
            shared: true,
            buildAction: BuildAction(targets: ["\(name)"]),
            runAction: RunAction.runAction(configuration: "Debug", options: .options(language: "fr"))
        )
    }

    static func l10nEN(name: String) -> Scheme {
        Scheme(
            name: "\(name) 🇺🇸",
            shared: true,
            buildAction: BuildAction(targets: ["\(name)"]),
            runAction: RunAction.runAction(configuration: "Debug", options: .options(language: "en"))
        )
    }
}

func l10nSchemes(name: String) -> [Scheme] {
    [
        .l10nFR(name: name),
        .l10nEN(name: name),
    ]
}
