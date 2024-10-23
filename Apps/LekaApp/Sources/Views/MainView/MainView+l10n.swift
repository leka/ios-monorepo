// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

// swiftlint:disable line_length nesting

extension l10n {
    enum MainView {
        enum Sidebar {
            enum CategoryLabel {
                static let home = LocalizedString("lekaapp.main_view.sidebar.category_label.home", value: "Home", comment: "The title of the category 'Home'")
                static let search = LocalizedString("lekaapp.main_view.sidebar.category_label.search", value: "Search", comment: "The title of the category 'Search'")
                static let news = LocalizedString("lekaapp.main_view.sidebar.category_label.news", value: "News", comment: "The title of the category 'News'")
                static let resourcesFirstSteps = LocalizedString("lekaapp.main_view.sidebar.category_label.resources_first_steps", value: "First steps", comment: "The title of the resources sub category 'First Steps'")
                static let resourcesVideo = LocalizedString("lekaapp.main_view.sidebar.category_label.resources_video", value: "Videos", comment: "The title of the resources sub category 'Videos'")
                static let resourcesDeepDive = LocalizedString("lekaapp.main_view.sidebar.category_label.resources_deep_dive", value: "Deep Dive", comment: "The title of the resources sub category 'DeepDive'")
                static let curriculums = LocalizedString("lekaapp.main_view.sidebar.category_label.curriculums", value: "Curriculums", comment: "The title of the category 'Curriculums'")
                static let activities = LocalizedString("lekaapp.main_view.sidebar.category_label.activities", value: "Activities", comment: "The title of the category 'Activities'")
                static let gamepads = LocalizedString("lekaapp.main_view.sidebar.category_label.gamepads", value: "Gamepads", comment: "The title of the category 'Gamepads'")
                static let stories = LocalizedString("lekaapp.main_view.sidebar.category_label.stories", value: "Stories", comment: "The title of the category 'Stories'")
                static let caregivers = LocalizedString("lekaapp.main_view.sidebar.category_label.caregivers", value: "Caregivers", comment: "The title of the category 'Caregivers'")
                static let carereceivers = LocalizedString("lekaapp.main_view.sidebar.category_label.carereceivers", value: "Care Receivers", comment: "The title of the category 'Care Receivers'")
                static let none = LocalizedString("lekaapp.main_view.sidebar.category_label.none", value: "Select a category", comment: "The title of the category 'none'")
            }

            static let navigationTitle = LocalizedString("lekaapp.main_view.sidebar.navigation_title", value: "Leka App", comment: "The title of the sidebar")

            static let sectionInformation = LocalizedString("lekaapp.main_view.sidebar.section.information", value: "Information", comment: "The title of the section 'Information'")

            static let sectionResources = LocalizedString("lekaapp.main_view.sidebar.section_resources", value: "Resources", comment: "The title of the section 'Resources'")

            static let sectionContent = LocalizedString("lekaapp.main_view.sidebar.section.content", value: "Content", comment: "The title of the section 'Content'")

            static let sectionUsers = LocalizedString("lekaapp.main_view.sidebar.section.monitoring", value: "Users", comment: "The title of the section 'Users'")

            static let sectionLibrary = LocalizedString("lekaapp.main_view.sidebar.section.library", value: "Library", comment: "The title of the section 'Library'")
        }

        enum DetailView {
            static let disconnectedLibraryMessage = LocalizedString("lekaapp.main_view.detailView.disconnected_library_message", value: "Log in to your account to access your personal library.", comment: "The message to invite users to connect to display the Library")
        }
    }
}

// swiftlint:enable line_length nesting
