// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - StyleManager

// TODO: (@ladislas) Replace by DesignSystem
class StyleManager: ObservableObject {
    @Published var accentColor: Color?
    @Published var colorScheme: ColorScheme = .light

    func setDefaultColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }

    func toggleAccentColor() {
        self.accentColor = if self.accentColor == nil {
            DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
        } else {
            nil
        }
    }

    func toggleColorScheme() {
        self.colorScheme = self.colorScheme == .light ? .dark : .light
    }
}

// MARK: - LekaActivityUIExplorerApp

@main
struct LekaActivityUIExplorerApp: App {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var styleManager: StyleManager = .init()

    var body: some Scene {
        WindowGroup {
            NavigationView()
                .tint(self.styleManager.accentColor)
                .preferredColorScheme(self.styleManager.colorScheme)
                .environmentObject(self.styleManager)
                .onAppear {
                    self.styleManager.setDefaultColorScheme(self.colorScheme)
                }
        }
    }
}
