// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

let kActivities: [ActivityDeprecated] = [
    // ? Filename format
    // ? touchToSelect: activity-touchToSelect-<number_of_answers>-<answer_type>
    // ? dragAndDropIntoZones:   activity-dragAndDropIntoZones-<number_of_zones>-<number_of_answers>-<answer_type>

    ContentKit.decodeActivityDeprecated("activity-medley"),
    ContentKit.decodeActivityDeprecated("activity-colorBingo"),
    ContentKit.decodeActivityDeprecated("activity-danceFreeze"),

    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-colors"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-colors-shuffle_choices"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-colors-shuffle_exercises"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-colors-shuffle_sequences"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-image"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-mixed"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-multipe_right_answers-colors"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-sfsymbols"),
    ContentKit.decodeActivityDeprecated("activity-touchToSelect-one_right_answer-emojis"),

    ContentKit.decodeActivityDeprecated("activity-listenThenTouchToSelect-mixed-images"),
    ContentKit.decodeActivityDeprecated("activity-observeThenTouchToSelect-mixed-colors"),

    ContentKit.decodeActivityDeprecated("activity-dragAndDropIntoZones-one_zone-one_right_answer-image"),
    // ContentKit.decodeActivity("activity-dragAndDropIntoZones-one_zone-one_right_answer-colors"),
    ContentKit.decodeActivityDeprecated("activity-dragAndDropIntoZones-two_zones-multiple_right_answers-images"),
    // ContentKit.decodeActivity("activity-dragAndDropIntoZones-mixed-mixed-mixed"),

    ContentKit.decodeActivityDeprecated("activity-dragAndDropToAssociate-mixed-images"),

    ContentKit.decodeActivityDeprecated("remote-standard"),
    ContentKit.decodeActivityDeprecated("remote-arrow"),
    ContentKit.decodeActivityDeprecated("activity-hideAndSeek"),
    ContentKit.decodeActivityDeprecated("activity-xylophone-pentatonic"),
    ContentKit.decodeActivityDeprecated("activity-xylophone-heptatonic"),
    ContentKit.decodeActivityDeprecated("activity-melody"),
    ContentKit.decodeActivityDeprecated("activity-pairing"),
]

// MARK: - GEKNewSystemView

struct GEKNewSystemView: View {
    @State var currentActivity: ActivityDeprecated?

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
                ActivityView(viewModel: ActivityViewViewModelDeprecated(activity: activity))
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
