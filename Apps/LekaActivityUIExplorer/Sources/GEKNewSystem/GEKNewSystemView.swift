// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

let kActivities: [Activity] = [
    // ? Filename format
    // ? touchToSelect: activity-touchToSelect-<number_of_answers>-<answer_type>
    // ? dragAndDropIntoZones:   activity-dragAndDropIntoZones-<number_of_zones>-<number_of_answers>-<answer_type>

    ContentKit.decodeActivity("activity-medley"),
    ContentKit.decodeActivity("activity-colorBingo"),
    ContentKit.decodeActivity("activity-danceFreeze"),

    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-colors"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-colors-shuffle_choices"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-colors-shuffle_exercises"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-colors-shuffle_sequences"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-image"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-mixed"),
    ContentKit.decodeActivity("activity-touchToSelect-multipe_right_answers-colors"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-sfsymbols"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-emojis"),

    ContentKit.decodeActivity("activity-listenThenTouchToSelect-mixed-images"),
    ContentKit.decodeActivity("activity-observeThenTouchToSelect-mixed-colors"),

    ContentKit.decodeActivity("activity-dragAndDropIntoZones-one_zone-one_right_answer-image"),
    // ContentKit.decodeActivity("activity-dragAndDropIntoZones-one_zone-one_right_answer-colors"),
    ContentKit.decodeActivity("activity-dragAndDropIntoZones-two_zones-multiple_right_answers-images"),
    // ContentKit.decodeActivity("activity-dragAndDropIntoZones-mixed-mixed-mixed"),

    ContentKit.decodeActivity("activity-dragAndDropToAssociate-mixed-images"),

    ContentKit.decodeActivity("remote-standard"),
    ContentKit.decodeActivity("remote-arrow"),
    ContentKit.decodeActivity("activity-hideAndSeek"),
    ContentKit.decodeActivity("activity-xylophone-pentatonic"),
    ContentKit.decodeActivity("activity-xylophone-heptatonic"),
    ContentKit.decodeActivity("activity-melody"),
    ContentKit.decodeActivity("activity-pairing"),
]

// MARK: - GEKNewSystemView

struct GEKNewSystemView: View {
    @State var currentActivity: Activity?

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(kActivities, id: \.id) { activity in
                    Button(activity.name) {
                        self.currentActivity = activity
                    }
                }
            }
            .fullScreenCover(item: self.$currentActivity) {
                self.currentActivity = nil
            } content: { activity in
                ActivityView(viewModel: ActivityViewViewModel(activity: activity))
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("List of Activities")
    }
}

#Preview {
    GEKNewSystemView()
}
