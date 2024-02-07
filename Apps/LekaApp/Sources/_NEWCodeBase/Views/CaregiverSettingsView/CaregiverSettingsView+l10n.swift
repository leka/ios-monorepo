// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum CaregiverSettingsView {
        enum AppearanceRow {
            static let title = LocalizedString("caregiver_settings_view.appearance_section.appearance_row.title", value: "Dark Mode", comment: "Appearance Row title")
        }

        enum AccentColorRow {
            static let title = LocalizedString("caregiver_settings_view.appearance_section.accent_color_row.title", value: "Color Theme", comment: "AccentColor Row title")
        }

        static let navigationTitle = LocalizedString("caregiver_settings_view.navigation_title", value: "Profil of ", comment: "The navigation title of Caregiver Settings View")

        static let saveButtonLabel = LocalizedString("caregiver_settings_view.save_button_label", value: "Save", comment: "Save button label of Caregiver Settings View")

        static let closeButtonLabel = LocalizedString("caregiver_settings_view.close_button_label", value: "Close", comment: "Close button label of Caregiver Settings View")
    }
}

// swiftlint:enable line_length nesting
