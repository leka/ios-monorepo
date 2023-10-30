// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public class ExerciseSharedData: ObservableObject {
    @Published var state: ExerciseState = .idle
}
