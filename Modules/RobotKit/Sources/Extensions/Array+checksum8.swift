// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

extension Array where Element == UInt8 {
    public var checksum8: UInt8 {
        var checksum: Int = 0

        for value in self {
            checksum = (Int(value) + checksum) % 256
        }

        return UInt8(checksum)
    }
}
