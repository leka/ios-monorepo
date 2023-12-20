// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

// MARK: - Experiment

struct Experiment: Identifiable {
    var id = UUID().uuidString
    var name: String = ""
}

// MARK: - ExperimentListView

struct ExperimentListView: View {
    @State var currentActivity: Experiment?

    let kExperiments: [Experiment] = [
        Experiment(name: "Sort images"),
        Experiment(name: "Sort colors"),
        Experiment(name: "Sequencing"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(self.kExperiments, id: \.id) { activity in
                    Button(activity.name) {
                        self.currentActivity = activity
                    }
                }
            }
            .fullScreenCover(item: self.$currentActivity) {
                self.currentActivity = nil
            } content: { activity in
                if activity.name == "Sort images" {
                    DragAndDropToSortImagesActivityView()
                } else if activity.name == "Sort colors" {
                    DragAndDropToSortColorsActivityView()
                } else {
                    DragAndDropToSequenceActivityView()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Experimentation")
    }
}

#Preview {
    ExperimentListView()
}
