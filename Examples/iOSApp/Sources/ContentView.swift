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
            DetailView()
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

struct DetailView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    var body: some View {
        Group {
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

struct View1: View {

    @State var value: Int = 0

    init() {
        print("View1 init")
    }

    var body: some View {
        ZStack {
            Rectangle().fill(Color.red).edgesIgnoringSafeArea(.all)
            Text("Value: \(value)")
                .foregroundColor(.white)
                .font(.title)
                .onTapGesture {
                    value += 1
                }
                .onAppear {
                    print("View 1 Text appeared")
                }
        }
        .onTapGesture {
            print("View1 tapped")
        }
        .onAppear {
            print("View1 appeared")
        }
    }
}

#Preview {
    ContentView()
        .previewInterfaceOrientation(.landscapeLeft)
}
