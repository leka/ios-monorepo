// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - PlaceholderExerciseView

struct ExercisePlaceholderView: View {
    @State var count = 0

    var body: some View {
        Text("Placeholder Exercise View")

        Text("Counter: \(self.count)")
        Button("Press me") {
            self.count += 1
        }
        .buttonStyle(.bordered)
    }
}
