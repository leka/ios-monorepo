// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension MainView {
    struct CategoryLabel: View {
        // MARK: Lifecycle

        // swiftlint:disable cyclomatic_complexity body_length
        init(category: Navigation.Category) {
            self.category = category

            switch category {
                case .home:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.home.characters)
                    self.systemImage = "house"

                case .search:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.search.characters)
                    self.systemImage = "magnifyingglass"

                case .news:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.news.characters)
                    self.systemImage = "lightbulb.max"

                case .resourcesFirstSteps:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.resourcesFirstSteps.characters)
                    self.systemImage = "shoeprints.fill"

                case .resourcesVideo:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.resourcesVideo.characters)
                    self.systemImage = "film"

                case .resourcesDeepDive:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.resourcesDeepDive.characters)
                    self.systemImage = "paperclip"

                case .curriculums:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.curriculums.characters)
                    self.systemImage = "graduationcap"

                case .activities:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.activities.characters)
                    self.systemImage = "dice"

                case .stories:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.stories.characters)
                    self.systemImage = "text.book.closed"

                case .gamepads:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.gamepads.characters)
                    self.systemImage = "gamecontroller"

                case .caregivers:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.caregivers.characters)
                    self.systemImage = "person.3.fill"

                case .carereceivers:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.carereceivers.characters)
                    self.systemImage = "figure.2.arms.open"

                case .allPublishedActivities:
                    self.title = "Published Activities"
                    self.systemImage = "list.bullet"

                case .allDraftActivities:
                    self.title = "Draft Activities"
                    self.systemImage = "list.bullet.rectangle"

                case .allTemplateActivities:
                    self.title = "Template Activities"
                    self.systemImage = "list.bullet.below.rectangle"

                case .rasterImageList:
                    self.title = "Raster Image List"
                    self.systemImage = "photo.circle"

                case .vectorImageList:
                    self.title = "Vector Image List"
                    self.systemImage = "photo.circle.fill"

                case .demo:
                    self.title = "Demo"
                    self.systemImage = "play.rectangle"

                case .personalLibraryCurriculums:
                    self.title = "Personal Library - Curriculums"
                    self.systemImage = "graduationcap.fill"

                case .personalLibraryActivities:
                    self.title = "Personal Library - Activities"
                    self.systemImage = "dice.fill"

                case .personalLibraryStories:
                    self.title = "Personal Library - Stories"
                    self.systemImage = "text.book.closed.fill"

                case .personalLibraryGamepads:
                    self.title = "Personal Library - Gamepads"
                    self.systemImage = "gamecontroller.fill"
            }
        }

        // swiftlint:enable cyclomatic_complexity body_length

        // MARK: Internal

        let category: Navigation.Category
        let title: String
        let systemImage: String

        var body: some View {
            Label(self.title, systemImage: self.systemImage)
                .tag(self.category)
        }
    }
}

#Preview {
    MainView.CategoryLabel(category: .activities)
}
