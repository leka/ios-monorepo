// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public class StyleManager: ObservableObject {
    // MARK: Lifecycle

    public init(accentColor: Color? = nil, colorScheme: ColorScheme = .light) {
        self.accentColor = accentColor
        self.colorScheme = colorScheme
    }

    // MARK: Public

    @Published public var accentColor: Color?
    @Published public var colorScheme: ColorScheme

    public func setDefaultColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }

    public func toggleAccentColor() {
        self.accentColor = if self.accentColor == nil {
            DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
        } else {
            nil
        }
    }

    public func toggleColorScheme() {
        self.colorScheme = self.colorScheme == .light ? .dark : .light
    }
}
