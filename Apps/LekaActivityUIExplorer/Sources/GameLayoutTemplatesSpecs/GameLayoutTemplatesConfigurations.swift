// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesConfigurations: ObservableObject {

    @Published var preferred3AnswersLayout: AlternativeLayout = .basic
    @Published var preferred4AnswersLayout: AlternativeLayout = .spaced

    @Published var answerSamples = [
        "dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6", "dummy_arobase", "dummy_ampersand",
        "dummy_percent", "dummy_hashtag",
    ]
    @Published var allTemplatesPreviews = [
        "LayoutTemplate_1", "LayoutTemplate_2", "LayoutTemplate_3", "LayoutTemplate_3_inline",
        "LayoutTemplate_4", "LayoutTemplate_4_spaced", "LayoutTemplate_4_inline", "LayoutTemplate_6",
        "xylophoneTemplate",
    ]
    //    @Published var templatesPreviews = [
    //        "LayoutTemplate_1", "LayoutTemplate_2", "LayoutTemplate_3", "LayoutTemplate_4_spaced", "LayoutTemplate_6",
    //    ]
    //    @Published var templatesPreviewsAlternatives3 = ["LayoutTemplate_3", "LayoutTemplate_3_inline"]
    //    @Published var templatesPreviewsAlternatives4 = [
    //        "LayoutTemplate_4_spaced", "LayoutTemplate_4", "LayoutTemplate_4_inline",
    //    ]
    @Published var typesOfActivity: [String] = ["touch_to_select", "listen_then_touch_to_select"]

    // MARK: - Setup Editor when being fed a new activity (from yaml or models)
    func setupEditor(with: Activity) {
        preferred3AnswersLayout = .basic
        preferred4AnswersLayout = .spaced
        //        templatesPreviews[2] = templatesPreviewsAlternatives3[0]
        //        templatesPreviews[3] = templatesPreviewsAlternatives4[0]
    }
}
