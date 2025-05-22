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

    public private(set) var accentColor: Color?
    public private(set) var colorScheme: ColorScheme

    public func setDefaultColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }

    public func setAccentColor(_ color: Color?) {
        self.accentColor = color
    }

    public func setColorScheme(_ scheme: ColorScheme) {
        self.colorScheme = scheme
    }
}
