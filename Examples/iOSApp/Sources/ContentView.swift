// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

struct ContentView: View {

    @EnvironmentObject var navigation: Navigation

    var body: some View {
        NavigationSplitView {
            List(navigation.categories, id: \.self, selection: $navigation.selectedCategory) { category in
                Text(category.rawValue)
                    .tag(category)
                    .onTapGesture {
                        navigation.selectedCategory = category
                        print("Selected category: \(navigation.selectedCategory?.rawValue ?? "n/a")")
                    }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Categories")
        } detail: {
            NavigationStack(path: $navigation.path) {
                Group {
                    if let selectedCategory = navigation.selectedCategory {
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
    }
}

#Preview {
    let navigation: Navigation = Navigation()

    return ContentView()
        .environmentObject(navigation)
        .previewInterfaceOrientation(.landscapeLeft)
}
