// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

public enum ColorTheme: String, Codable {
    case darkBlue
    case blue
    case purple
    case red
    case orange
    case yellow
    case green
    case gray

    // MARK: Public

    public var color: Color {
        switch self {
            case .darkBlue: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
            case .blue: .blue
            case .purple: .purple
            case .red: .red
            case .orange: .orange
            case .yellow: .yellow
            case .green: .green
            case .gray: .gray
        }
    }
}
