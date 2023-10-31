// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

let kActivities: [Activity] = [
    // ? Filename format
    // ? touchToSelect: activity-touchToSelect-<number_of_answers>-<answer_type>
    // ? dragAndDrop:   activity-dragAndDrop-<number_of_zones>-<number_of_answers>-<answer_type>

    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-colors"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-colors-shuffle_choices"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-image"),
    ContentKit.decodeActivity("activity-touchToSelect-one_right_answer-mixed"),
    // ContentKit.decodeActivity("activity-touchToSelect-multipe_right_answers-mixed"),
    ContentKit.decodeActivity("activity-touchToSelect-multipe_right_answers-colors"),
    // ContentKit.decodeActivity("activity-touchToSelect-multipe_right_answers-images"),
    // ContentKit.decodeActivity("activity-touchToSelect-multipe_right_answers-mixed"),

    ContentKit.decodeActivity("activity-listenThenTouchToSelect-mixed-images"),
    ContentKit.decodeActivity("activity-observeThenTouchToSelect-mixed-colors"),

    // ContentKit.decodeActivity("activity-dragAndDrop-one_zone-one_right_answer-image"),
    // ContentKit.decodeActivity("activity-dragAndDrop-one_zone-one_right_answer-colors"),
    // ContentKit.decodeActivity("activity-dragAndDrop-one_zone-one_right_answer-mixed"),
    // ContentKit.decodeActivity("activity-dragAndDrop-one_zone-multiple_right_answer-images"),
    // ContentKit.decodeActivity("activity-dragAndDrop-one_zone-multiple_right_answer-colors"),
    // ContentKit.decodeActivity("activity-dragAndDrop-one_zone-multiple_right_answer-mixed"),

    // ContentKit.decodeActivity("activity-dragAndDrop-two_zones-one_right_answer-image"),
    // ContentKit.decodeActivity("activity-dragAndDrop-two_zones-one_right_answer-colors"),
    // ContentKit.decodeActivity("activity-dragAndDrop-two_zones-one_right_answer-mixed"),
    // ContentKit.decodeActivity("activity-dragAndDrop-two_zones-multiple_right_answer-images"),
    // ContentKit.decodeActivity("activity-dragAndDrop-two_zones-multiple_right_answer-colors"),
    // ContentKit.decodeActivity("activity-dragAndDrop-two_zones-multiple_right_answer-mixed"),

    ContentKit.decodeActivity("activity-medley"),
]

struct ContentView: View {

    @State var currentActivity: Activity?

    var body: some View {
        VStack(spacing: 30) {
            ForEach(kActivities, id: \.id) { activity in
                Button(activity.name) {
                    currentActivity = activity
                }
            }
        }
        .fullScreenCover(item: $currentActivity) {
            currentActivity = nil
        } content: { activity in
            ActivityView(viewModel: ActivityViewViewModel(activity: activity))
        }
        .buttonStyle(.borderedProminent)
    }

}

#Preview {
    ContentView()
}
