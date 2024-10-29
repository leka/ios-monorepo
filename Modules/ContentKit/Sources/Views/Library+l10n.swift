// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum Library {
        enum MenuActions {
            static let addTolibraryButtonLabel = LocalizedString("content_kit.library_menu_actions.add_to_library_button_label",
                                                                 bundle: ContentKitResources.bundle,
                                                                 value: "Add to Library",
                                                                 comment: "Add to library button label")

            static let removeFromlibraryButtonLabel = LocalizedString("content_kit.library_menu_actions.remove_from_library_button_label",
                                                                      bundle: ContentKitResources.bundle,
                                                                      value: "Delete from Library",
                                                                      comment: "Remove from library button label")
        }
    }
}
