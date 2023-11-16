// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

public protocol DraggableChoice {
    var value: String { get }
    var type: Exercise.UIElementType { get }
}
