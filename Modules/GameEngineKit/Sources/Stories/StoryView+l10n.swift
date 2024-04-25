// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// swiftlint:disable nesting line_length

extension l10n {
    enum StoryView {
        enum QuitStoryAlert {
            static let title = LocalizedString("story_view.quit_story_alert.title",
                                               bundle: GameEngineKitResources.bundle,
                                               value: "Quit story?",
                                               comment: "Quit story alert title")

            static let message = LocalizedString("story_view.quit_story_alert.message",
                                                 bundle: GameEngineKitResources.bundle,
                                                 value: """
                                                     Do you want to save your progress before quitting?
                                                     """,
                                                 comment: "Quit story alert message")

            static let quitWithoutSavingButtonLabel = LocalizedString("story_view.quit_story_alert.quit_without_saving_button_label",
                                                                      bundle: GameEngineKitResources.bundle,
                                                                      value: "Quit Without Saving",
                                                                      comment: "Quit story alert quit without saving button label")

            static let saveQuitButtonLabel = LocalizedString("story_view.quit_story_alert.save_quit_button_label",
                                                             bundle: GameEngineKitResources.bundle,
                                                             value: "Save and Quit",
                                                             comment: "Quit story alert save and quit button label")

            static let cancelButtonLabel = LocalizedString("story_view.quit_story_alert.cancel_button_label",
                                                           bundle: GameEngineKitResources.bundle,
                                                           value: "Cancel",
                                                           comment: "Quit story alert cancel button label")
        }
    }
}

// swiftlint:enable nesting line_length
