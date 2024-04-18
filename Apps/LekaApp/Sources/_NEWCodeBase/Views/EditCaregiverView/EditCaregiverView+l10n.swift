// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum EditCaregiverView {
        enum AppearanceRow {
            static let title = LocalizedString("edit_caregiver_view.appearance_section.appearance_row.title", value: "Dark Mode", comment: "Appearance Row title")
        }

        enum AccentColorRow {
            static let title = LocalizedString("edit_caregiver_view.appearance_section.accent_color_row.title", value: "Color Theme", comment: "AccentColor Row title")
        }

        static let navigationTitle = LocalizedString("edit_caregiver_view.navigation_title", value: "Edit my profile", comment: "The navigation title of Edit Caregiver View")

        static let saveButtonLabel = LocalizedString("edit_caregiver_view.save_button_label", value: "Save", comment: "Save button label of Edit Caregiver View")

        static let closeButtonLabel = LocalizedString("edit_caregiver_view.close_button_label", value: "Close", comment: "Close button label of Edit Caregiver View")
    }
}

// swiftlint:enable line_length nesting
