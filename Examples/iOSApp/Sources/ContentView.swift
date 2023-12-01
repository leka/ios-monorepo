// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

struct ContentView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    var body: some View {
        NavigationSplitView {
            List(navigation.categories, selection: $navigation.selectedCategory) { category in
                Label(title(for: category), systemImage: image(for: category))
                    .disabled(navigation.disableUICompletly)
            }
            .navigationTitle("Categories")
        } detail: {
            NavigationStack(path: $navigation.path) {
                switch navigation.selectedCategory {
                    case .home:
                        HomeView()
                    case .activities:
                        ActivityListView()
                    case .curriculums:
                        CurriculumListView()
                    case .none:
                        Text("Select a category")
                }
            }
        }
    }

    private func title(for category: Category) -> String {
        switch category {
            case .home:
                "Home"
            case .activities:
                "Activities"
            case .curriculums:
                "Curriculums"
        }
    }

    private func image(for category: Category) -> String {
        switch category {
            case .home:
                "house"
            case .activities:
                "figure.run"
            case .curriculums:
                "books.vertical"
        }
    }

}

#Preview {
    ContentView()
        .previewInterfaceOrientation(.landscapeLeft)
}
