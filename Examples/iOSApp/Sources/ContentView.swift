// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class ContentViewViewModel: ObservableObject {

    private var navigation: Navigation = Navigation.shared

//    @Published var topViewCategory: Category? = .home

//    init() {
//        navigation.$selectedCategory
//            .assign(to: &$topViewCategory)
//    }

    public func titleForCategory(_ category: Category) -> String {
        switch category {
            case .home:
                "Home"
            case .activities:
                "Activities"
            case .curriculums:
                "Curriculums"
        }
    }

    public func imageForCategory(_ category: Category) -> String {
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

    @ObservedObject var navigation: Navigation = Navigation.shared

    @StateObject var viewModel = ContentViewViewModel()

    var body: some View {
        NavigationSplitView {
            List(navigation.categories, selection: $navigation.selectedCategory) { category in
                Label(viewModel.titleForCategory(category), systemImage: viewModel.imageForCategory(category))
            }
            .navigationTitle("Categories")
        } detail: {
            DetailView()
        }
    }

}

struct DetailView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    @State var title: String = "NO TITLE"

    private var cancellables = Set<AnyCancellable>()

    init() {
        print("init DetailView")
    }

    var body: some View {
        ZStack {
            Group {
                HomeView()
                    .opacity(navigation.selectedCategory == .home ? 1 : 0)


                ActivityListView()
                    .opacity(navigation.selectedCategory == .activities ? 1 : 0)


                CurriculumListView()
                    .opacity(navigation.selectedCategory == .curriculums ? 1 : 0)

            }
            .navigationTitle(title)
            .onReceive(navigation.$selectedCategory) { category in
                switch category {
                    case .home:
                        self.title = "Home"
                    case .activities:
                        self.title = "Activities"
                    case .curriculums:
                        self.title = "Curriculums"
                    case .none:
                        self.title = "NIL TITLE"
                }
            }
        }
    }

}

#Preview {
    ContentView()
        .previewInterfaceOrientation(.landscapeLeft)
}
