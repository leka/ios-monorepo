// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Observation
import SwiftUI

@Observable
public class StyleManager {
    // MARK: Lifecycle

    public init(accentColor: Color? = nil, colorScheme: ColorScheme = .light) {
        self.accentColor = accentColor
        self.colorScheme = colorScheme
    }

    // MARK: Public

    public static let shared = StyleManager(accentColor: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)

    public var accentColor: Color?
    public var colorScheme: ColorScheme

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
