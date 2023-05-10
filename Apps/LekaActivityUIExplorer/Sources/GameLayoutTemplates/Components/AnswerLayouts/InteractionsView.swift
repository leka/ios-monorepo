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
            switch configuration.currentActivityType {
                case .touchToSelect: touchToSelectTemplate
                case .listenThenTouchToSelect: listenThenTouchToSelectTemplate
                case .colorQuest: colorQuestTemplate
                case .xylophone: XylophoneLayout()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var colorQuestTemplate: some View {
        switch gameEngine.allAnswers.count {
            case 1: ColorQuestOneAnswerLayout()
            case 2: ColorQuestTwoAnswersLayout()
            case 3: ColorQuestThreeAnswersLayout()
            default: Text("Sélectionner un modèle")
        }
    }

    @ViewBuilder
    private var touchToSelectTemplate: some View {
        switch gameEngine.allAnswers.count {
            case 1: OneAnswerLayout()
            case 2: TwoAnswersLayout()
            case 3:
                if configuration.preferred3AnswersLayout == .inline {
                    ThreeAnswersLayoutInline()
                } else {
                    ThreeAnswersLayout()
                }
            case 4:
                if configuration.preferred4AnswersLayout == .inline {
                    FourAnswersLayoutInline()
                } else {
                    FourAnswersLayout()
                }
            case 5: FiveAnswersLayout()
            case 6: SixAnswersLayout()
            default: Text("Sélectionner un modèle")
        }
    }

    @ViewBuilder
    private var listenThenTouchToSelectTemplate: some View {
        switch gameEngine.allAnswers.count {
            case 1: ListenOneAnswerLayout()
            case 2: ListenTwoAnswersLayout()
            case 3:
                if configuration.preferred3AnswersLayout == .inline {
                    ListenThreeAnswersLayoutInline()
                } else {
                    ListenThreeAnswersLayout()
                }
            case 4:
                if configuration.preferred4AnswersLayout == .inline {
                    ListenFourAnswersLayoutInline()
                } else {
                    ListenFourAnswersLayout()
                }
            case 6: ListenSixAnswersLayout()
            default: Text("Sélectionner un modèle")
        }
    }
}
