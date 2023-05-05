// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesConfigurations: ObservableObject {

    @Published var preferred3AnswersLayout: AlternativeLayout = .basic
    @Published var preferred4AnswersLayout: AlternativeLayout = .basic

    @Published var answerSamples = [
        "dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6", "dummy_arobase", "dummy_ampersand",
        "dummy_percent", "dummy_hashtag",
    ]
    @Published var touchToSelectPreviews = [
        "LayoutTemplate_1", "LayoutTemplate_2", "LayoutTemplate_3", "LayoutTemplate_3_inline",
        "LayoutTemplate_4", "LayoutTemplate_4_inline", "LayoutTemplate_5", "LayoutTemplate_6",
    ]
    @Published var listenThenTouchToSelectPreviews = [
        "LayoutTemplate_1", "LayoutTemplate_2", "LayoutTemplate_3", "LayoutTemplate_3_inline",
        "LayoutTemplate_4", "LayoutTemplate_4_inline", "LayoutTemplate_6",
    ]
    @Published var colorQuestPreviews = [
        "ColorQuest_1", "ColorQuest_2", "ColorQuest_3",
    ]
    @Published var miscPreviews = [
        "xylophoneTemplate"
    ]

    // unused for now
    // @Published var typesOfActivity: [String] = ["touch_to_select", "listen_then_touch_to_select", "xylophone", "color_quest"]
}
