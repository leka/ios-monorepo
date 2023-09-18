// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension UInt16 {

    public var highByte: UInt8 {
        UInt8(self >> 8)
    }

    public var lowByte: UInt8 {
        UInt8(self & 0xff)
    }

    public var data: Data {
        Data([self.highByte, self.lowByte])
    }

}
