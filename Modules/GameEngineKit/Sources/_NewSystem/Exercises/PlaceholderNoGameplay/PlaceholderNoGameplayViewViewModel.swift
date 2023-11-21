// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

class PlaceholderNoGameplayViewViewModel: ObservableObject {

    @ObservedObject var exercicesSharedData: ExerciseSharedData

    init(shared: ExerciseSharedData? = nil) {
        self.exercicesSharedData = shared ?? ExerciseSharedData()
    }

    func updateState() {
        exercicesSharedData.state = .completed
    }

}
