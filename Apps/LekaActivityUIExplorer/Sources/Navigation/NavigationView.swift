// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct NavigationView: View {

    @Environment(\.colorScheme) var colorScheme
    @State var preferedColorScheme: ColorScheme = .light

    @ObservedObject var navigation: Navigation = Navigation.shared

    @State private var expandDesignSystemApple: Bool = true
    @State private var expandDesignSystemLeka: Bool = true

    var body: some View {
        NavigationSplitView {
            List(selection: $navigation.selectedCategory) {
                CategoryLabel(category: .home)

                Section("Design System (Apple)", isExpanded: $expandDesignSystemApple) {
                    CategoryLabel(category: .designSystemAppleFonts)
                    CategoryLabel(category: .designSystemAppleButtons)
                    CategoryLabel(category: .designSystemAppleColorsSwiftUI)
                    CategoryLabel(category: .designSystemAppleColorsUIKit)
                }

                Section("Design System (Leka)", isExpanded: $expandDesignSystemLeka) {
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
    }

    struct CategoryLabel: View {
        let category: Category
        let title: String
        let systemImage: String

        init(category: Category) {
            self.category = category

            switch category {
                case .home:
                    self.title = "Home"
                    self.systemImage = "house"

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

        var body: some View {
            Label(title, systemImage: systemImage)
                .tag(category)
        }
    }

}

#Preview {
    NavigationView()
        .previewInterfaceOrientation(.landscapeLeft)
}
