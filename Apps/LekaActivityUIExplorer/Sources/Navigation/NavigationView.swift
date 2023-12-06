// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DesignKit
import RobotKit
import SwiftUI

// MARK: - NavigationViewViewModel

class NavigationViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        Robot.shared.isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                self.isRobotConnect = isConnected
            }
            .store(in: &cancellables)
    }

    // MARK: Internal

    @Published var isDesignSystemAppleExpanded: Bool = false
    @Published var isDesignSystemLekaExpanded: Bool = false

    @Published var isRobotConnectionPresented: Bool = false

    @Published var isRobotConnect: Bool = false

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []
}

// MARK: - NavigationView

struct NavigationView: View {
    struct CategoryLabel: View {
        // MARK: Lifecycle

        init(category: Category) {
            self.category = category

            switch category {
                case .home:
                    self.title = "Home"
                    self.systemImage = "house"

                case .activities:
                    self.title = "Activities"
                    self.systemImage = "dice"

                case .designSystemAppleFonts:
                    self.title = "Apple Fonts"
                    self.systemImage = "textformat"

                case .designSystemAppleButtons:
                    self.title = "Apple Buttons"
                    self.systemImage = "button.horizontal"

                case .designSystemAppleColorsSwiftUI:
                    self.title = "Apple Colors SwiftUI"
                    self.systemImage = "swatchpalette.fill"

                case .designSystemAppleColorsUIKit:
                    self.title = "Apple Colors UIKit"
                    self.systemImage = "swatchpalette"

                case .designSystemLekaButtons:
                    self.title = "Leka Buttons"
                    self.systemImage = "button.horizontal"

                case .designSystemLekaColorsSwiftUI:
                    self.title = "Leka Colors SwiftUI"
                    self.systemImage = "swatchpalette.fill"
            }
        }

        // MARK: Internal

        let category: Category
        let title: String
        let systemImage: String

        var body: some View {
            Label(title, systemImage: systemImage)
                .tag(category)
        }
    }

    @Environment(\.colorScheme) var colorScheme
    @State var preferedColorScheme: ColorScheme = .light

    @ObservedObject var navigation: Navigation = Navigation.shared
    @StateObject var viewModel: NavigationViewViewModel = .init()

    var body: some View {
        NavigationSplitView {
            List(selection: $navigation.selectedCategory) {
                CategoryLabel(category: .home)

                Button {
                    viewModel.isRobotConnectionPresented.toggle()
                } label: {
                    Label(viewModel.isRobotConnect ? "Disconnect robot" : "Connect robot", systemImage: "link")
                        .foregroundStyle(viewModel.isRobotConnect ? .green : .orange)
                }

                Section("Activities") {
                    CategoryLabel(category: .activities)
                }

                Section("Design System (Apple)", isExpanded: $viewModel.isDesignSystemAppleExpanded) {
                    CategoryLabel(category: .designSystemAppleFonts)
                    CategoryLabel(category: .designSystemAppleButtons)
                    CategoryLabel(category: .designSystemAppleColorsSwiftUI)
                    CategoryLabel(category: .designSystemAppleColorsUIKit)
                }

                Section("Design System (Leka)", isExpanded: $viewModel.isDesignSystemLekaExpanded) {
                    CategoryLabel(category: .designSystemLekaButtons)
                    CategoryLabel(category: .designSystemLekaColorsSwiftUI)
                }
            }
            // TODO(@ladislas): remove if not necessary
            // .disabled(navigation.disableUICompletly)
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        preferedColorScheme = preferedColorScheme == .light ? .dark : .light
                    } label: {
                        Image(systemName: "circle.lefthalf.filled")
                    }
                }
            }
        } detail: {
            NavigationStack(path: $navigation.path) {
                switch navigation.selectedCategory {
                    case .home:
                        Text("Hello, Home!")
                            .font(.largeTitle)
                            .bold()

                    case .activities:
                        GEKNewSystemView()

                    case .designSystemAppleFonts:
                        DesignSystemApple.FontsView()

                    case .designSystemAppleButtons:
                        DesignSystemApple.ButtonsView()

                    case .designSystemAppleColorsSwiftUI:
                        DesignSystemApple.ColorsSwiftUIView()

                    case .designSystemAppleColorsUIKit:
                        DesignSystemApple.ColorsUIKitView()

                    case .designSystemLekaButtons:
                        DesignSystemLeka.ButtonsView()

                    case .designSystemLekaColorsSwiftUI:
                        DesignSystemLeka.ColorsSwiftUIView()

                    case .none:
                        Text("Select a category")
                }
            }
        }
        .preferredColorScheme(preferedColorScheme)
        .onAppear {
            preferedColorScheme = colorScheme
        }
        .fullScreenCover(isPresented: $viewModel.isRobotConnectionPresented) {
            RobotConnectionView(viewModel: RobotConnectionViewModel())
        }
    }
}

#Preview {
    NavigationView()
        .previewInterfaceOrientation(.landscapeLeft)
}
