// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InteractionsView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @ObservedObject var templateDefaults: BaseDefaults

    var body: some View {
        VStack {
            Spacer()
            if gameEngine.currentActivity.activityType == "xylophone" {
                XylophoneLayout()
            } else if gameEngine.currentActivity.activityType == "color_quest" {
                if gameEngine.allAnswers.count == 1 {
                    ColorQuestOneAnswerLayout(templateDefaults: templateDefaults)
                } else if gameEngine.allAnswers.count == 2 {
                    ColorQuestTwoAnswersLayout(templateDefaults: templateDefaults)
                } else if gameEngine.allAnswers.count == 3 {
                    ColorQuestThreeAnswersLayout(templateDefaults: templateDefaults)
                }
            } else {
                HStack(spacing: 0) {
                    if gameEngine.currentActivity.activityType == "listen_then_touch_to_select" {
                        PlaySoundButton()
                            .padding(20)
                        Divider()
                            .opacity(0.4)
                            .frame(maxHeight: 500)
                            .padding(.vertical, 20)
                    }
                    Spacer()
                    Group {
                        if gameEngine.allAnswers.count == 1 {
                            OneAnswerLayout(templateDefaults: templateDefaults)
                        } else if gameEngine.allAnswers.count == 2 {
                            TwoAnswersLayout(templateDefaults: templateDefaults)
                        } else if gameEngine.allAnswers.count == 3 {
                            if configuration.preferred3AnswersLayout == .inline {
                                ThreeAnswersLayoutInline(templateDefaults: templateDefaults)
                            } else {
                                ThreeAnswersLayout(templateDefaults: templateDefaults)
                            }
                        } else if gameEngine.allAnswers.count == 4 {
                            if configuration.preferred4AnswersLayout == .inline {
                                FourAnswersLayoutInline(templateDefaults: templateDefaults)
                            } else {
                                FourAnswersLayout(templateDefaults: templateDefaults)
                            }
                        } else if gameEngine.allAnswers.count == 5 {
                            FiveAnswersLayout(templateDefaults: templateDefaults)
                        } else if gameEngine.allAnswers.count == 6 {
                            SixAnswersLayout(templateDefaults: templateDefaults)
                        } else {
                            Text("Sélectionner un modèle")
                        }
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
