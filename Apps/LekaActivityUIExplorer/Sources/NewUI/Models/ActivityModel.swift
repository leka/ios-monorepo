// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let instructions: String
    let view: AnyView
}
