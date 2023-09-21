// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct ContextModel: Identifiable, Equatable {
    public let id: UUID = UUID()
    public let name: String
    public let file: String
    public var rightAnswers: [String]

    public init(name: String, file: String, rightAnswers: [String]) {
        self.name = name
        self.file = file
        self.rightAnswers = rightAnswers
    }
}
