// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// swiftlint:disable nesting line_length

extension l10n {
    enum StoryView {
        enum QuitStoryAlert {
            static let title = LocalizedString("game_engine_kit.story_view.quit_story_alert.title",
                                               bundle: GameEngineKitResources.bundle,
                                               value: "Leave story?",
                                               comment: "Quit story alert title")

            static let message = LocalizedString("game_engine_kit.story_view.quit_story_alert.message",
                                                 bundle: GameEngineKitResources.bundle,
                                                 value: """
                                                     Are you sure you want to quit this activity?
                                                     """,
                                                 comment: "Quit story alert message")

            static let quitButtonLabel = LocalizedString("game_engine_kit.story_view.quit_story_alert.quit_button_label",
                                                         bundle: GameEngineKitResources.bundle,
                                                         value: "Quit",
                                                         comment: "Quit story alert quit button label")

            static let cancelButtonLabel = LocalizedString("game_engine_kit.story_view.quit_story_alert.cancel_button_label",
                                                           bundle: GameEngineKitResources.bundle,
                                                           value: "Cancel",
                                                           comment: "Quit story alert cancel button label")
        }

        static let finishButtonLabel = LocalizedString("game_engine_kit.story_view.finish_button_label",
                                                       bundle: GameEngineKitResources.bundle,
                                                       value: "Finish",
                                                       comment: "Finish story button label")
    }
}

// swiftlint:enable nesting line_length
