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

    @State var path: [Activity] = [] {
        didSet {
            print("didSet path: \(path)")
        }
    }

    var body: some View {
        CustomSplitView {
            List(navigation.categories, selection: $navigation.selectedCategory) { category in
                Label(viewModel.titleForCategory(category), systemImage: viewModel.imageForCategory(category))
            }
            .navigationTitle("Categories")
        } detail: {
//            NavigationStack(path: $path) {
                DetailView()
//            }
            //                .id(navigation.selectedCategory)
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
                //                HomeView()
                //                    .opacity(navigation.selectedCategory == .home ? 1 : 0)
                //
                //
                ////                NavigationView {
                //                    ActivityListView()
                ////                }.navigationViewStyle(.stack)
                //
                //                .opacity(navigation.selectedCategory == .activities ? 1 : 0)
                //
                //
                //                CurriculumListView()
                //                    .opacity(navigation.selectedCategory == .curriculums ? 1 : 0)

                View1()
                    //                HomeView()
                    .opacity(navigation.selectedCategory == .home ? 1 : 0)
                //                View2()
                ActivityListView()
                    .opacity(navigation.selectedCategory == .activities ? 1 : 0)
                View3()
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

struct View2: View {
    @State var value: Int = 0

    init() {
        print("View2 init")
    }
    var body: some View {
        ZStack {
            Rectangle().fill(Color.green).edgesIgnoringSafeArea(.all)
            Text("Value: \(value)")
                .foregroundColor(.white)
                .font(.title)
                .onTapGesture {
                    value += 1
                }
                .onAppear {
                    print("View 2 Text appeared")
                }
        }

        .onTapGesture {
            print("View2 tapped")
        }
        .onAppear {
            print("View2 appeared")
        }
    }
}

struct View3: View {
    @State var value: Int = 0

    init() {
        print("View3 init")
    }

    var body: some View {
        ZStack {
            Rectangle().fill(Color.blue).edgesIgnoringSafeArea(.all)
            Text("Value: \(value)")
                .foregroundColor(.white)
                .font(.title)
                .onTapGesture {
                    value += 1
                }
                .onAppear {
                    print("View 3 Text appeared")
                }
        }
        .onTapGesture {
            print("View3 tapped")
        }
        .onAppear {
            print("View3 appeared")
        }
    }
}

struct CustomSplitView<Sidebar: View, Detail: View>: View {
    let sidebar: () -> Sidebar
    let detail: () -> Detail
    @State private var isSidebarCollapsed = false

    init(@ViewBuilder sidebar: @escaping () -> Sidebar, @ViewBuilder detail: @escaping () -> Detail) {
        self.sidebar = sidebar
        self.detail = detail
    }

    var body: some View {
        HStack(spacing: 0) {
            if !isSidebarCollapsed {
                VStack {
                    Button(action: { isSidebarCollapsed = true }) {
                        Image(systemName: "chevron.left")
                            .padding()
                    }
                    sidebar()
                }
                .frame(width: 250)
                .transition(.move(edge: .leading))
            }

            detail()

            if isSidebarCollapsed {
                Button(action: { isSidebarCollapsed = false }) {
                    Image(systemName: "chevron.right")
                        .padding()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.default, value: isSidebarCollapsed)
    }
}

#Preview {
    ContentView()
        .previewInterfaceOrientation(.landscapeLeft)
}
