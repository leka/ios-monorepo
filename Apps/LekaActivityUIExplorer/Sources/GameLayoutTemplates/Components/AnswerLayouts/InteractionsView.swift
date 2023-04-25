// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InteractionsView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    var body: some View {
        VStack {
            Spacer()
            if gameEngine.currentActivity.activityType == "xylophone" {
                XylophoneLayout()
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
                            OneAnswerLayout()
                        } else if gameEngine.allAnswers.count == 2 {
                            TwoAnswersLayout()
                        } else if gameEngine.allAnswers.count == 3 {
                            switch configuration.preferred3AnswersLayout {
                                case .inline: ThreeAnswersLayoutInline()
                                default: ThreeAnswersLayout()
                            }
                        } else if gameEngine.allAnswers.count == 4 {
                            switch configuration.preferred4AnswersLayout {
                                case .inline: FourAnswersLayoutInline()
                                // case .spaced: FourAnswersLayoutSpaced()
                                default: FourAnswersLayout()
                            }
                        } else if gameEngine.allAnswers.count == 5 {
                            FiveAnswersLayout()
                        } else if gameEngine.allAnswers.count == 6 {
                            SixAnswersLayout()
                        } else {
                            Text("Sélectionner un modèle")
                        }
                    }
                    // .offset(x: gameEngine.currentActivity.activityType == "listen_then_touch_to_select" ? -120 : 0)
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
