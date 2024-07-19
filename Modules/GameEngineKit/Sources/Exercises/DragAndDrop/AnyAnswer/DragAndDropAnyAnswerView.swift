// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

public struct DragAndDropAnyAnswerView: View {
    // MARK: Lifecycle

    // TODO(@HPezz): Add hints variable
    // let hints: Bool

    public init(
        choices: [DragAndDropAnyAnswer.Choice], dropZoneA: DragAndDropAnyAnswer.DropZone.Details,
        dropZoneB: DragAndDropAnyAnswer.DropZone.Details? = nil, shuffle: Bool = false
    ) {
        _viewModel = StateObject(wrappedValue: ViewModel(choices: choices, shuffle: shuffle))
        self.dropZoneA = dropZoneA
        self.dropZoneB = dropZoneB
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DragAndDropAnyAnswer.Payload else {
            log.error("Exercise payload is not .dragAndDrop")
            fatalError("💥 Exercise payload is not .dragAndDrop")
        }

        _viewModel = StateObject(
            wrappedValue: ViewModel(choices: payload.choices, shuffle: payload.shuffleChoices, shared: data))

        self.dropZoneA = payload.dropZoneA
        self.dropZoneB = payload.dropZoneB
    }

    // MARK: Public

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: self.makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                if let dropZoneB {
                    self.scene = DragAndDropAnyAnswerView.TwoZonesScene(
                        viewModel: self.viewModel, hints: false, dropZoneA: self.dropZoneA, dropZoneB: dropZoneB
                    )
                } else {
                    self.scene = DragAndDropAnyAnswerView.OneZoneScene(
                        viewModel: self.viewModel, hints: true, dropZoneA: self.dropZoneA
                    )
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    // MARK: Internal

    let dropZoneA: DragAndDropAnyAnswer.DropZone.Details
    let dropZoneB: DragAndDropAnyAnswer.DropZone.Details?

    // MARK: Private

    @StateObject private var viewModel: ViewModel
    @State private var scene: SKScene = .init()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropAnyAnswerView.BaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = self.viewModel
        return finalScene
    }
}
