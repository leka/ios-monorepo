// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

public struct DragAndDropIntoZonesView: View {
    // MARK: Lifecycle

    // TODO(@HPezz): Add hints variable
    // let hints: Bool

    public init(
        choices: [DragAndDropIntoZones.Choice], dropZoneA: DragAndDropIntoZones.DropZone.Details,
        dropZoneB: DragAndDropIntoZones.DropZone.Details? = nil, shuffle: Bool = false
    ) {
        _viewModel = StateObject(wrappedValue: ViewModel(choices: choices, shuffle: shuffle))
        self.dropZoneA = dropZoneA
        self.dropZoneB = dropZoneB
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DragAndDropIntoZones.Payload else {
            logGEK.error("Exercise payload is not .dragAndDrop")
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
                    self.scene = DragAndDropIntoZonesView.TwoZonesScene(
                        viewModel: self.viewModel, hints: false, dropZoneA: self.dropZoneA, dropZoneB: dropZoneB
                    )
                } else {
                    self.scene = DragAndDropIntoZonesView.OneZoneScene(
                        viewModel: self.viewModel, hints: true, dropZoneA: self.dropZoneA
                    )
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    // MARK: Internal

    let dropZoneA: DragAndDropIntoZones.DropZone.Details
    let dropZoneB: DragAndDropIntoZones.DropZone.Details?

    // MARK: Private

    @StateObject private var viewModel: ViewModel
    @State private var scene: SKScene = .init()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropIntoZonesView.BaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = self.viewModel
        return finalScene
    }
}
