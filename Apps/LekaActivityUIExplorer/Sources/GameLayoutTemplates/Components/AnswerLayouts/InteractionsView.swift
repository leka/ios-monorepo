// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InteractionsView: View {

    @EnvironmentObject var gameEngine: GameEngine

    var body: some View {
        VStack {
            interface
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var interface: some View {
        switch gameEngine.currentActivity.activityType {
            case .touchToSelect: touchToSelectInterfaces
            case .listenThenTouchToSelect: listenThenTouchToSelectInterfaces
            case .dragAndDrop: dragAndDropInterfaces
            case .colorQuest: colorQuestInterfaces
            case .xylophone, .remote, .danceFreeze, .hideAndSeek, .melody: otherInterfaces
        }
    }

    @ViewBuilder
    private var touchToSelectInterfaces: some View {
        switch gameEngine.interface {
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
            default:
                OneAnswerLayout()
        }
    }

    @ViewBuilder
    private var listenThenTouchToSelectInterfaces: some View {
        switch gameEngine.interface {
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
            default:
                ListenOneAnswerLayout()
        }
    }

    @ViewBuilder
    private var dragAndDropInterfaces: some View {
        switch gameEngine.interface {
            case .basket2:
                DragAndDropSceneView(withTemplate: BasketTwoScene())
            case .basket4:
                DragAndDropSceneView(withTemplate: BasketFourScene())
            case .basketEmpty:
                DragAndDropSceneView(withTemplate: EmptyBasketScene())
            case .dropArea1:
                DragAndDropSceneView(withTemplate: DropAreaOneAssetOne())
            case .dropArea3:
                DragAndDropSceneView(withTemplate: DropAreaOneAssetsThree())
            case .dropArea2Asset1:
                DragAndDropSceneView(withTemplate: DropAreaTwoAssetOne())
            case .dropArea2Assets2:
                DragAndDropSceneView(withTemplate: DropAreaTwoAssetsTwo())
            case .dropArea2Assets6:
                DragAndDropSceneView(withTemplate: DropAreaTwoAssetsSix())
            case .association4:
                DragAndDropSceneView(withTemplate: AssociationFour())
            case .association6:
                DragAndDropSceneView(withTemplate: AssociationSix())
            default:
                DragAndDropSceneView(withTemplate: BasketOneScene())
        }
    }

    @ViewBuilder
    private var colorQuestInterfaces: some View {
        switch gameEngine.interface {
            case .colorQuest2:
                ColorQuestTwoAnswersLayout()
            case .colorQuest3:
                ColorQuestThreeAnswersLayout()
            default:
                ColorQuestOneAnswerLayout()
        }
    }

    @ViewBuilder
    private var otherInterfaces: some View {
        switch gameEngine.interface {
            case .remoteStandard:
                RemoteStandardView()
            case .remoteArrow:
                RemoteArrowView()
            case .danceFreeze:
                DanceFreezeLauncher()
            case .hideAndSeek:
                HideAndSeekLauncher()
            case .melody1:
                MelodyLayout()
            default:
                XylophoneLayout()

        }
    }
}

struct InteractionsView_Previews: PreviewProvider {
    static var gameEngine: GameEngine {
        let gameEngine = GameEngine()
        gameEngine.interface = .melody1
        return gameEngine
    }

    static var previews: some View {
        InteractionsView()
            .environmentObject(gameEngine)
            .environmentObject(GameLayoutTemplatesDefaults())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
