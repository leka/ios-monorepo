// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension UInt16 {
    var highByte: UInt8 {
        UInt8(self >> 8)
    }

    var lowByte: UInt8 {
        UInt8(self & 0xFF)
    }

    var data: Data {
        Data([self.highByte, self.lowByte])
    }
}
