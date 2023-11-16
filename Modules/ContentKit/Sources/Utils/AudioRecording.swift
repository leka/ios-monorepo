// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct AudioRecording: Codable, Hashable, Equatable {
    public let name: String
    public let file: String

    public init(name: String, file: String) {
        self.name = name
        self.file = file
    }
}
