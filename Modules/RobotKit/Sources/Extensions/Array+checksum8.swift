// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension [UInt8] {
    var checksum8: UInt8 {
        var checksum = 0

        for value in self {
            checksum = (Int(value) + checksum) % 256
        }

        return UInt8(checksum)
    }
}
