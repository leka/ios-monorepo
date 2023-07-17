// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// swiftlint:disable identifier_name
public enum MusicalColor {
    case `do`, re, mi, fa, sol, la, si

    public func color() -> Color {
        switch self {
            case .do:
                return .pink
            case .re:
                return .red
            case .mi:
                return .orange
            case .fa:
                return .yellow
            case .sol:
                return .green
            case .la:
                return .blue
            case .si:
                return .purple
        }
    }
}
// swiftlint:enable identifier_name

public class MusicalGameplayData {
    public let colors: [Color]

    public init(
        notes: [MusicalColor]
    ) {
        self.colors = notes.map {
            $0.color()
        }
    }
}
