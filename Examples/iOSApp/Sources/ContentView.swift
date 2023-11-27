// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class ContentViewViewModel: ObservableObject {

    public func titleForCategory(_ category: Navigation.Category) -> String {
        switch category {
            case .home:
                "Home"
            case .activities:
                "Activities"
            case .curriculums:
                "Curriculums"
        }
    }

    public func imageForCategory(_ category: Navigation.Category) -> String {
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

struct ContentView: View {

    @EnvironmentObject var navigation: Navigation

    @StateObject var viewModel = ContentViewViewModel()

    var body: some View {
        NavigationSplitView {
            List(navigation.categories, selection: $navigation.selectedCategory) { category in
                Label(viewModel.titleForCategory(category), systemImage: viewModel.imageForCategory(category))
                    .tag(category)
                    .onTapGesture {
                        // TODO(@ladislas): handle double tap to go back to root
                        navigation.selectCategory(category)
                    }
            }
            .listStyle(.sidebar)
            .navigationTitle("Categories")
        } detail: {
            switch navigation.selectedCategory {
                case .home:
                    Text("Hello, Home!")
                        .navigationTitle("What's new?")
                case .activities:
                    // ? Fix animation w/ multiple navigation stacks, see https://developer.apple.com/forums/thread/728132
                    NavigationStack(path: $navigation.activitiesNavPath.animation(.linear(duration: 0))) {
                        ActivityListView()
                    }
                case .curriculums:
                    // ? Fix animation w/ multiple navigation stacks, see https://developer.apple.com/forums/thread/728132
                    NavigationStack(path: $navigation.curriculumsNavPath.animation(.linear(duration: 0))) {
                        CurriculumListView()
                    }
                case .none:
                    Text("Select a category")
            }
        }
    }

}

#Preview {
    let navigation: Navigation = Navigation()

    return ContentView()
        .environmentObject(navigation)
        .previewInterfaceOrientation(.landscapeLeft)
}
