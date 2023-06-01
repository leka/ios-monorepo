// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InteractionsView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    private var launchText: Text = Text("Sélectionner un modèle")

    var body: some View {
        VStack {
            Spacer()
            switch gameEngine.currentActivity.activityType {
                case .touchToSelect: touchToSelectTemplate
                case .listenThenTouchToSelect: listenThenTouchToSelectTemplate
                case .colorQuest: colorQuestTemplate
                case .xylophone: XylophoneLayout()
                case .remote: remoteTemplate
                case .colorQuestGK: colorQuestGKTemplate
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
            default: launchText
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
            default: launchText
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
            default: launchText
        }
    }

    @ViewBuilder
    private var remoteTemplate: some View {
        switch gameEngine.allAnswers.count {
            case 1: RemoteStandardView()
            case 2: RemoteArrowView()
            default:
                launchText
        }
    }

    @ViewBuilder
    private var colorQuestGKTemplate: some View {
        switch gameEngine.allAnswers.count {
            case 1: ColorQuestGKOneAnswerLayout()
            case 2: ColorQuestGKTwoAnswersLayout()
            case 3: ColorQuestGKThreeAnswersLayout()
            default: launchText
        }
    }
}
