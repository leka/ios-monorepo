// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - ColorScheme + Codable, RawRepresentabl

extension ColorScheme: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue {
            case "light": self = .light
            case "dark": self = .dark
            default: fatalError("Invalid ColorScheme")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    public var rawValue: String {
        switch self {
            case .light: return "light"
            case .dark: return "dark"
            @unknown default: return "light"
        }
    }
}
