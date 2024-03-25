// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// MARK: - l10n.SuccessFailureView

// swiftlint:disable line_length

extension l10n {
    enum SuccessFailureView {
        static let successPercentageLabel = LocalizedStringInterpolation("gameenginekit.success_failure_view.success_percentage_label",
                                                                         bundle: ContentKitResources.bundle,
                                                                         value: "%.0f%% of success!",
                                                                         comment: "Success and Failure view success percentage label")

        static let successCheeringLabel = LocalizedString("gameenginekit.success_failure_view.success_cheering_label",
                                                          bundle: ContentKitResources.bundle,
                                                          value: "Well done, you've succeeded this activity!",
                                                          comment: "Success and Failure view cheering label")

        static let failureCheeringLabel = LocalizedString("gameenginekit.success_failure_view.failure_cheering_label",
                                                          bundle: ContentKitResources.bundle,
                                                          value: "Try again!",
                                                          comment: "Success and Failure view cheering label")

        static let quitWithoutSavingButtonLabel = LocalizedString("gameenginekit.success_failure_view.quit_without_saving_button_label",
                                                                  bundle: ContentKitResources.bundle,
                                                                  value: "Quit without saving",
                                                                  comment: "Success and Failure view quit without saving button label")

        static let saveQuitButtonLabel = LocalizedString("gameenginekit.success_failure_view.save_quit_button_label",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Save",
                                                         comment: "Success and Failure view save & quit button label")
    }
}

// swiftlint:enable line_length
