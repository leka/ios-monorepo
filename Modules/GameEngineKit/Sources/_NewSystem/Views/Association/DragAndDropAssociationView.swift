// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

public struct DragAndDropAssociationView: View {

    @StateObject private var viewModel: DragAndDropAssociationViewViewModel
    @State private var scene: SKScene = SKScene()

    public init(choices: [AssociationChoice], shuffle: Bool = false) {
        self._viewModel = StateObject(
            wrappedValue: DragAndDropAssociationViewViewModel(choices: choices, shuffle: shuffle)
        )
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case .association(let payload) = exercise.payload else {
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
                if viewModel.choices.count == 4 {
                    scene = DragAndDropAssociationFourChoicesScene(viewModel: viewModel)
                } else {
                    scene = DragAndDropAssociationSixChoicesScene(viewModel: viewModel)
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropAssociationBaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel
        return finalScene
    }

}
