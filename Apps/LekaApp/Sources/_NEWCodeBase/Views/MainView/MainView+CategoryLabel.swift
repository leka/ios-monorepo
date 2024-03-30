// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension MainView {
    struct CategoryLabel: View {
        // MARK: Lifecycle

        init(category: Navigation.Category) {
            self.category = category

            switch category {
                case .home:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.home.characters)
                    self.systemImage = "house"

                case .news:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.news.characters)
                    self.systemImage = "lightbulb.max"

                case .resources:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.resources.characters)
                    self.systemImage = "book.and.wrench"

                case .curriculums:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.curriculums.characters)
                    self.systemImage = "graduationcap"

                case .activities:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.activities.characters)
                    self.systemImage = "dice"

                case .remotes:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.remotes.characters)
                    self.systemImage = "gamecontroller"

                case .caregivers:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.caregivers.characters)
                    self.systemImage = "person.3.fill"

                case .carereceivers:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.carereceivers.characters)
                    self.systemImage = "figure.2.arms.open"

                case .allActivities:
                    self.title = "All Activities"
                    self.systemImage = "list.bullet"

                case .rasterImageList:
                    self.title = "Raster Image List"
                    self.systemImage = "photo.circle"

                case .vectorImageList:
                    self.title = "Vector Image List"
                    self.systemImage = "photo.circle.fill"
            }
        }

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
