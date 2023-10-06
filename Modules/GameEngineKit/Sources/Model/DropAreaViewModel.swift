// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct DropAreaViewModel: Identifiable, Equatable {
    public let id: UUID = UUID()
    public let file: String
    public let size: CGSize
    public let hints: Bool

    public init(file: String, size: CGSize, hints: Bool = false) {
        self.file = file
        self.size = size
        self.hints = hints
    }
}
