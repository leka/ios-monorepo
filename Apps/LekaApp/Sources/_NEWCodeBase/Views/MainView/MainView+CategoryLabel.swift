// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension MainView {
    struct CategoryLabel: View {
        // MARK: Lifecycle

        init(category: Navigation.Category) {
            self.category = category

            switch category {
                case .news:
                    self.title = "What's new"
                    self.systemImage = "lightbulb.max"

                case .resources:
                    self.title = "Resources"
                    self.systemImage = "book.and.wrench"

                case .curriculums:
                    self.title = "Curriculums"
                    self.systemImage = "graduationcap"

                case .activities:
                    self.title = "Activities"
                    self.systemImage = "dice"

                case .remotes:
                    self.title = "Remotes"
                    self.systemImage = "gamecontroller"

                case .stories:
                    self.title = "Stories"
                    self.systemImage = "book"
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
