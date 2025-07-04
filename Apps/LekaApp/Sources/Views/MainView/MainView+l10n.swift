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
                static let explore = LocalizedString("lekaapp.main_view.sidebar.category_label.explore", value: "Explore", comment: "The title of the category 'Explore'")
                static let objectives = LocalizedString("lekaapp.main_view.sidebar.category_label.objectives", value: "Learning Objectives", comment: "The title of the category 'Learning Objectives'")
                static let search = LocalizedString("lekaapp.main_view.sidebar.category_label.search", value: "Search", comment: "The title of the category 'Search'")
                static let news = LocalizedString("lekaapp.main_view.sidebar.category_label.news", value: "News", comment: "The title of the category 'News'")
                static let resourcesFirstSteps = LocalizedString("lekaapp.main_view.sidebar.category_label.resources_first_steps", value: "First steps", comment: "The title of the resources sub category 'First Steps'")
                static let resourcesVideo = LocalizedString("lekaapp.main_view.sidebar.category_label.resources_video", value: "Videos", comment: "The title of the resources sub category 'Videos'")
                static let resourcesDeepDive = LocalizedString("lekaapp.main_view.sidebar.category_label.resources_deep_dive", value: "Deep Dive", comment: "The title of the resources sub category 'DeepDive'")
                static let curriculums = LocalizedString("lekaapp.main_view.sidebar.category_label.curriculums", value: "Curriculums", comment: "The title of the category 'Curriculums'")
                static let educationalGames = LocalizedString("lekaapp.main_view.sidebar.category_label.educational_games", value: "Educational Games", comment: "The title of the category 'Educational Games'")
                static let gamepads = LocalizedString("lekaapp.main_view.sidebar.category_label.gamepads", value: "Gamepads", comment: "The title of the category 'Gamepads'")
                static let stories = LocalizedString("lekaapp.main_view.sidebar.category_label.stories", value: "Stories", comment: "The title of the category 'Stories'")
                static let caregivers = LocalizedString("lekaapp.main_view.sidebar.category_label.caregivers", value: "Caregivers", comment: "The title of the category 'Caregivers'")
                static let carereceivers = LocalizedString("lekaapp.main_view.sidebar.category_label.carereceivers", value: "Care Receivers", comment: "The title of the category 'Care Receivers'")
                static let none = LocalizedString("lekaapp.main_view.sidebar.category_label.none", value: "Select a category", comment: "The title of the category 'none'")
                static let sharedLibraryFavorites = LocalizedString("lekaapp.main_view.sidebar.category_label.shared_library_favorites", value: "Favorites", comment: "The title of the category 'Shared Library Favorites'")
                static let sharedLibraryCurriculums = LocalizedString("lekaapp.main_view.sidebar.category_label.shared_library_curriculums", value: "Curriculums", comment: "The title of the category 'Shared Library Curriculums'")
                static let sharedLibraryActivities = LocalizedString("lekaapp.main_view.sidebar.category_label.shared_library_activities", value: "Activities", comment: "The title of the category 'Shared Library Activities'")
                static let sharedLibraryStories = LocalizedString("lekaapp.main_view.sidebar.category_label.shared_library_stories", value: "Stories", comment: "The title of the category 'Shared Library Stories'")
            }

            static let navigationTitle = LocalizedString("lekaapp.main_view.sidebar.navigation_title", value: "Leka App", comment: "The title of the sidebar")

            static let sectionResources = LocalizedString("lekaapp.main_view.sidebar.section_resources", value: "Resources", comment: "The title of the section 'Resources'")

            static let sectionContent = LocalizedString("lekaapp.main_view.sidebar.section.content", value: "Content", comment: "The title of the section 'Content'")

            static let sectionUsers = LocalizedString("lekaapp.main_view.sidebar.section.monitoring", value: "Users", comment: "The title of the section 'Users'")

            static let sectionSharedLibrary = LocalizedString("lekaapp.main_view.sidebar.section.shared_library", value: "Shared Library", comment: "The title of the section 'Shared Library'")
        }

        enum DetailView {
            static let disconnectedSharedLibraryMessage = LocalizedString("lekaapp.main_view.detailView.disconnected_shared_library_message", value: "Log in to your account to access your shared library.", comment: "The message to invite users to connect to display the Shared Library")
        }

        enum AppUpdateAlert {
            static let title = LocalizedString("lekaapp.main_view.app_update_alert.title", value: "New update available", comment: "The title of the alert to inform the user that an update is available")
            static let message = LocalizedString("lekaapp.main_view.app_update_alert.message", value: "Enjoy new features by updating to the latest version of Leka!", comment: "The message of the alert to inform the user that an update is available")
            static let action = LocalizedString("lekaapp.main_view.app_update_alert.action", value: "Update now", comment: "The action button of the alert to inform the user that an update is available")
            static let reminder = LocalizedString("lekaapp.main_view.app_update_alert.reminder", value: "Remind me later", comment: "The action button of the alert to inform the user that an os update is available")
        }

        enum OSUpdateAlert {
            static let title = LocalizedString("lekaapp.main_view.os_update_alert.title", value: "Update your iPad to the Latest iPadOS Version", comment: "The title of the alert to inform the user that an os update is available")
            static let message = LocalizedString("lekaapp.main_view.os_update_alert.message", value: "A new version of iPadOS is available! Update now to enjoy enhanced performance, security, and compatibility with the latest features of our app.", comment: "The message of the alert to inform the user that an os update is available")
            static let action = LocalizedString("lekaapp.main_view.os_update_alert.action", value: "Update now", comment: "The action button of the alert to inform the user that an os update is available")
            static let reminder = LocalizedString("lekaapp.main_view.os_update_alert.reminder", value: "Remind me later", comment: "The action button of the alert to inform the user that an os update is available")
        }

        enum RemovalAlert {
            static let errorTitle = LocalizedString(
                "lekaapp.main_view.removal_alert.error_title",
                value: "Error",
                comment: "Title of the alert when an error occurs during item removal"
            )

            static let confirmTitle = LocalizedString(
                "lekaapp.main_view.removal_alert.confirm_title",
                value: "Confirm Removal",
                comment: "Title of the alert when a user is about to remove a favorited item"
            )

            static let confirmMessage = LocalizedString(
                "lekaapp.main_view.removal_alert.confirm_message",
                value: "You have marked this item as a favorite. Are you sure you want to remove it from the shared library?",
                comment: "Message of the alert when a user is about to remove a favorited item"
            )

            static let confirmAction = LocalizedString(
                "lekaapp.main_view.removal_alert.confirm_action",
                value: "Remove",
                comment: "Action button text for confirming item removal"
            )

            static let cannotRemoveTitle = LocalizedString(
                "lekaapp.main_view.removal_alert.cannot_remove_title",
                value: "Cannot Remove Item",
                comment: "Title of the alert when an item cannot be removed due to being favorited by others"
            )

            static let cannotRemoveMessage = LocalizedString(
                "lekaapp.main_view.removal_alert.cannot_remove_message",
                value: "This item is favorited by other caregivers. You cannot remove it.",
                comment: "Message of the alert when an item cannot be removed because it is favorited by others"
            )

            static let okAction = LocalizedString(
                "lekaapp.main_view.removal_alert.ok_action",
                value: "OK",
                comment: "OK button text for alerts"
            )
        }
    }
}

// swiftlint:enable line_length nesting
