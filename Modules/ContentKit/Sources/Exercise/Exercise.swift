// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct Exercise: Codable {

    public let instructions: String
    public let category: Category
    public let interface: Interface
    public let gameplay: Gameplay
    public let action: Action?
    public let payload: Payload

}
