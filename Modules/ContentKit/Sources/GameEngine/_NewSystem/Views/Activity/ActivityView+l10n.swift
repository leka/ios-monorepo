// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// swiftlint:disable nesting

extension l10n {
    enum ActivityView {
        enum QuitActivityAlert {
            static let title = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.title",
                                               bundle: ContentKitResources.bundle,
                                               value: "Leave activity?",
                                               comment: "Quit activity alert title")

            static let message = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.message",
                                                 bundle: ContentKitResources.bundle,
                                                 value: """
                                                     Are you sure you want to quit this activity?
                                                     """,
                                                 comment: "Quit activity alert message")

            static let quitButtonLabel = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.quit_button_label",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Quit",
                                                         comment: "Quit activity alert quit button label")

            static let cancelButtonLabel = LocalizedString("game_engine_kit.activity_view.quit_activity_alert.cancel_button_label",
                                                           bundle: ContentKitResources.bundle,
                                                           value: "Cancel",
                                                           comment: "Quit activity alert cancel button label")
        }
    }
}

// swiftlint:enable nesting
