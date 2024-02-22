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

                case .stories:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.stories.characters)
                    self.systemImage = "book"

                case .sampleActivities:
                    self.title = "Sample activites"
                    self.systemImage = "testtube.2"

                case .carereceivers:
                    self.title = String(l10n.MainView.Sidebar.CategoryLabel.carereceivers.characters)
                    self.systemImage = "figure.2.arms.open"
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
