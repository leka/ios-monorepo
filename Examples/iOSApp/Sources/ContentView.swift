// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

struct ContentView: View {

    //    @EnvironmentObject var navigation: Navigation

    @ObservedObject var navigation = Navigation.shared

    var body: some View {
        NavigationSplitView {
            List(navigation.categories, id: \.self, selection: $navigation.coordinator.category) { category in
                Text(category.rawValue)
                    .tag(category)
                    .onTapGesture {
                        //                        navigation.selectedCategory = category
                        navigation.set(category: category)
                        print("Selected category: \(navigation.selectedCategory?.rawValue ?? "n/a")")
                    }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Categories")
        } detail: {
            NavigationStack(path: $navigation.coordinator.path) {
                Group {
                    if let selectedCategory = navigation.coordinator.category {
                        switch selectedCategory {
                            case .fruits:
                                FruitsDetailView()
                            case .animals:
                                AnimalsDetailView()
                            case .actions:
                                ActionsDetailView()
                        }
                    } else {
                        Text("Select a category")
                    }
                }
            }
        }
        .id(navigation.coordinator.category)
    }
}

#Preview {
    //    let navigation: Navigation = Navigation()

    ContentView()
        //        .environmentObject(navigation)
        .previewInterfaceOrientation(.landscapeLeft)
}
