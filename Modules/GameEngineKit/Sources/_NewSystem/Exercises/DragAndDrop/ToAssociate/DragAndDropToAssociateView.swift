// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import LogKit
import SpriteKit
import SwiftUI

public struct DragAndDropToAssociateView: View {

    enum Interface: Int {
        case twoChoices = 2
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    @StateObject private var viewModel: DragAndDropAssociationViewViewModel
    @State private var scene: SKScene = SKScene()

    public init(choices: [DragAndDropAssociation.Choice], shuffle: Bool = false) {
        self._viewModel = StateObject(
            wrappedValue: DragAndDropAssociationViewViewModel(choices: choices, shuffle: shuffle)
        )
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DragAndDropAssociation.Payload else {
            fatalError("Exercise payload is not .association")
        }

        self._viewModel = StateObject(
            wrappedValue: DragAndDropAssociationViewViewModel(
                choices: payload.choices,
                shuffle: payload.shuffleChoices,
                shared: data
            )
        )
    }

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                guard let interface = Interface(rawValue: viewModel.choices.count) else { return }

                switch interface {
                    case .twoChoices:
                        scene = TwoChoicesScene(viewModel: viewModel)
                    case .threeChoices:
                        scene = ThreeChoicesScene(viewModel: viewModel)
                    case .fourChoices:
                        scene = FourChoicesScene(viewModel: viewModel)
                    case .fiveChoices:
                        scene = FiveChoicesScene(viewModel: viewModel)
                    case .sixChoices:
                        scene = SixChoicesScene(viewModel: viewModel)
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? BaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel
        return finalScene
    }

}
