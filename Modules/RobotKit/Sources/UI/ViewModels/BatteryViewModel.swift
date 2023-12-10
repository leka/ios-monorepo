// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

public struct BatteryViewModel: Equatable {
    // MARK: Lifecycle

    public init(level: Int) {
        self.level = level
        switch level {
            case 0..<10:
                self.name = "battery.0"
                self.color = .red
            case 10..<25:
                self.name = "battery.25"
                self.color = .red
            case 25..<45:
                self.name = "battery.25"
                self.color = .orange
            case 45..<70:
                self.name = "battery.50"
                self.color = .yellow
            case 70..<95:
                self.name = "battery.75"
                self.color = .green
            case 95...100:
                self.name = "battery.100"
                self.color = .green
            default:
                self.name = "battery.0"
                self.color = .gray
        }
    }

    // MARK: Public

    public let level: Int
    public let name: String
    public let color: Color
}
