//
//  SplitView.swift
//  iOSApp
//
//  Created by Ladislas de Toldi on 30/11/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct SplitView<Sidebar, Content, Detail> : View where Sidebar : View, Content : View, Detail : View {

    let sidebar: () -> Sidebar
    let detail: () -> Detail

    @State private var isSidebarCollapsed = false

    @Environment(\.colorScheme) var colorScheme

    public init(@ViewBuilder sidebar: @escaping () -> Sidebar, @ViewBuilder detail: @escaping () -> Detail) where Content == EmptyView {
        self.sidebar = sidebar
        self.detail = detail
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: 0) {
                if !isSidebarCollapsed {
                    NavigationStack {
//                        VStack(alignment: .leading, spacing: 0) {
//                            Color(uiColor: colorScheme == .light ? .systemGray6 : .systemGray5)
//                                .ignoresSafeArea(.all, edges: [.top, .bottom])
//                                .frame(height: 71)

                            //                                .ignoresSafeArea(.all, edges: [.top, .bottom])
                            sidebar()
                            //                                .padding(.top, 50)
//                                .listStyle(.sidebar)
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button(action: { isSidebarCollapsed.toggle() }) {
                                            Image(systemName: "sidebar.left")
//                                                .padding()
                                        }
                                        .opacity(isSidebarCollapsed ? 0 : 1)
                                    }
                                }
//                                                            .navigationTitle("Categories")
//                                .title("Categories")
                            //                        }

//                        }
                    }
                    .frame(width: 250)
//                    .background(./*cyan*/)
                    .transition(.move(edge: .leading))

                }

//                NavigationStack {
                    detail()
                        .frame(maxWidth: .infinity)
//                        .zIndex(10)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
//                                Toggle(isOn: $isSidebarCollapsed) {
//                                    Image(systemName: "sidebar.left")
//                                }
                                Button(action: { isSidebarCollapsed.toggle() }) {
                                    Image(systemName: "sidebar.left")
//                                        .padding()
                                }
                                .opacity(isSidebarCollapsed ? 1 : 0)
                            }

                        }
//                }






            }
            .animation(.default, value: isSidebarCollapsed)


            if isSidebarCollapsed {
                Button(action: { isSidebarCollapsed = false }) {
                    Image(systemName: "sidebar.left")
//                        .padding()
                }
                //                        .transition(.move(edge: .leading))
            }
        }

    }
}

struct TitleModifier: ViewModifier {
    var title: String

    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding(.leading)
//                .padding(.l)
            content
        }
    }
}

// 2. Extension to View
extension View {
    func title(_ title: String) -> some View {
        self.modifier(TitleModifier(title: title))
    }
}

#Preview {

    struct SplitViewPreview: View {
        @State var darkModeOn = false
        var body: some View {
            SplitView {
                VStack(alignment: .leading, spacing: 0) {
                    List {
                        Section(header: Text("Section 1")) {
                            Label("Item 1", systemImage: "1.circle")
                            Label("Item 2", systemImage: "2.circle")
                            Label("Item 3", systemImage: "3.circle")
                        }

                        Section(header: Text("Section 2")) {
                            Label("Item 4", systemImage: "4.circle")
                            Label("Item 5", systemImage: "5.circle")
                            Label("Item 6", systemImage: "6.circle")
                        }
                    }
                    .listStyle(.sidebar)
                }
                .navigationTitle("Categories")
//                .title("Categories")
            } detail: {
                NavigationStack {
//                    ZStack {
//                        Rectangle()
//                            .fill(.teal)
//                            .edgesIgnoringSafeArea(.all)
                    VStack {
//                        Text("Main View")
//                            .font(.largeTitle)
//                            .bold()
//                            .foregroundStyle(.white)
                        ScrollView {
                            ForEach(0...100, id: \.self) {
                                Text("Item: \($0)")
                            }
                        }
                    }
                    .navigationTitle("Main View")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Toggle(isOn: $darkModeOn) {
                                Image(systemName: "circle.lefthalf.filled")
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Toggle(isOn: $darkModeOn) {
                                Image(systemName: "circle.lefthalf.filled")
                            }
                            .padding(.leading)
                        }
                    }
                    .preferredColorScheme(darkModeOn ? .dark : .light)

                }
            }
        }
    }

    return SplitViewPreview()

}
