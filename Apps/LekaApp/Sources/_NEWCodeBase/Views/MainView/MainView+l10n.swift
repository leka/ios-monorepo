// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum MainView {
        enum Sidebar {
            enum CategoryLabel {
                static let news = LocalizedString("main_view.sidebar.category_label.news", value: "News", comment: "The title of the category 'News'")
                static let resources = LocalizedString("main_view.sidebar.category_label.resources", value: "Resources", comment: "The title of the category 'Resources'")
                static let curriculums = LocalizedString("main_view.sidebar.category_label.curriculums", value: "Curriculums", comment: "The title of the category 'Curriculums'")
                static let activities = LocalizedString("main_view.sidebar.category_label.activities", value: "Activities", comment: "The title of the category 'Activities'")
                static let remotes = LocalizedString("main_view.sidebar.category_label.remotes", value: "Remotes", comment: "The title of the category 'Remotes'")
                static let stories = LocalizedString("main_view.sidebar.category_label.stories", value: "Stories", comment: "The title of the category 'Stories'")
                static let carereceivers = LocalizedString("main_view.sidebar.category_label.carereceivers", value: "Care Receivers", comment: "The title of the category 'Care Receivers'")
            }

            static let navigationTitle = LocalizedString("main_view.sidebar.navigation_title", value: "Leka App", comment: "The title of the sidebar")

            static let sectionInformation = LocalizedString("main_view.sidebar.section.information", value: "Information", comment: "The title of the section 'Information'")

            static let sectionContent = LocalizedString("main_view.sidebar.section.content", value: "Content", comment: "The title of the section 'Content'")

            static let sectionUsers = LocalizedString("main_view.sidebar.section.monitoring", value: "Users", comment: "The title of the section 'Users'")
        }
    }
}

// swiftlint:enable line_length nesting
