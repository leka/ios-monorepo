// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// MARK: - l10n.SuccessFailureView

extension l10n {
    enum SuccessFailureView {
        static let successPercentageLabel = LocalizedStringInterpolation("game_engine_kit.success_failure_view.success_percentage_label",
                                                                         bundle: ContentKitResources.bundle,
                                                                         value: "%.0f%% of success!",
                                                                         comment: "Success and Failure view success percentage label")

        static let successCheeringLabel = LocalizedString("game_engine_kit.success_failure_view.success_cheering_label",
                                                          bundle: ContentKitResources.bundle,
                                                          value: "Well done, you've succeeded this activity!",
                                                          comment: "Success and Failure view cheering label")

        static let failureCheeringLabel = LocalizedString("game_engine_kit.success_failure_view.failure_cheering_label",
                                                          bundle: ContentKitResources.bundle,
                                                          value: "Try again!",
                                                          comment: "Success and Failure view cheering label")

        static let quitButtonLabel = LocalizedString("game_engine_kit.success_failure_view.quit_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Quit",
                                                     comment: "Success and Failure view quit button label")
    }
}
