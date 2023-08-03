// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct SongModel: Hashable, Equatable {
    let id: UUID = UUID()
    let name: String
    let file: String

    public init(name: String, file: String) {
        self.name = name
        self.file = file
    }
}
