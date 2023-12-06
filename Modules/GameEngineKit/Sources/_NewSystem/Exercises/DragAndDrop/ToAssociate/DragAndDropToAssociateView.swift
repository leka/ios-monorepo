// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import LogKit
import SpriteKit
import SwiftUI

public struct DragAndDropToAssociateView: View {
    // MARK: Lifecycle

    public init(choices: [DragAndDropToAssociate.Choice], shuffle: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: ViewModel(choices: choices, shuffle: shuffle)
        )
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DragAndDropToAssociate.Payload else {
            fatalError("Exercise payload is not .association")
        }

        _viewModel = StateObject(
            wrappedValue: ViewModel(
                choices: payload.choices,
                shuffle: payload.shuffleChoices,
                shared: data
            )
        )
    }

    // MARK: Public

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

    // MARK: Internal

    enum Interface: Int {
        case twoChoices = 2
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    // MARK: Private

    @StateObject private var viewModel: ViewModel
    @State private var scene: SKScene = SKScene()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? BaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel
        return finalScene
    }
}
