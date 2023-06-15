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
            interface
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var interface: some View {
        switch gameEngine.interface {
            case .touch1:
                OneAnswerLayout()
            case .touch2:
                TwoAnswersLayout()
            case .touch3:
                ThreeAnswersLayout()
            case .touch3Inline:
                ThreeAnswersLayoutInline()
            case .touch4:
                FourAnswersLayout()
            case .touch4Inline:
                FourAnswersLayoutInline()
            case .touch5:
                FiveAnswersLayout()
            case .touch6:
                SixAnswersLayout()
            case .soundTouch1:
                ListenOneAnswerLayout()
            case .soundTouch2:
                ListenTwoAnswersLayout()
            case .soundTouch3:
                ListenThreeAnswersLayout()
            case .soundTouch3Inline:
                ListenThreeAnswersLayoutInline()
            case .soundTouch4:
                ListenFourAnswersLayout()
            case .soundTouch4Inline:
                ListenFourAnswersLayoutInline()
            case .soundTouch6:
                ListenSixAnswersLayout()
            case .basket1:
                DragAndDropSceneView(withTemplate: BasketOneScene())
            case .basket2:
                DragAndDropSceneView(withTemplate: BasketTwoScene())
            case .basket4:
                DragAndDropSceneView(withTemplate: BasketFourScene())
            case .basketEmpty:
                DragAndDropSceneView(withTemplate: EmptyBasketScene())
            case .colorQuest1:
                ColorQuestOneAnswerLayout()
            case .colorQuest2:
                ColorQuestTwoAnswersLayout()
            case .colorQuest3:
                ColorQuestThreeAnswersLayout()
            case .remoteStandard:
                RemoteStandardView()
            case .remoteArrow:
                RemoteArrowView()
            case .xylophone:
                XylophoneLayout()
        }
    }
}
