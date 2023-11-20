// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

public struct DragAndDropIntoZonesView: View {

    @StateObject private var viewModel: ViewModel
    @State private var scene: SKScene = SKScene()
    let dropZoneA: DragAndDropIntoZones.DropZone.Details
    let dropZoneB: DragAndDropIntoZones.DropZone.Details?
    // TODO(@HPezz): Add hints variable
    // let hints: Bool

    public init(
        choices: [DragAndDropIntoZones.Choice], dropZoneA: DragAndDropIntoZones.DropZone.Details,
        dropZoneB: DragAndDropIntoZones.DropZone.Details? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: ViewModel(choices: choices))
        self.dropZoneA = dropZoneA
        self.dropZoneB = dropZoneB
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DragAndDropIntoZones.Payload else {
            log.error("Exercise payload is not .dragAndDrop")
            fatalError("💥 Exercise payload is not .dragAndDrop")
        }

        self._viewModel = StateObject(
            wrappedValue: ViewModel(choices: payload.choices, shared: data))

        self.dropZoneA = payload.dropZoneA
        self.dropZoneB = payload.dropZoneB
    }

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                if let dropZoneB = dropZoneB {
                    scene = DragAndDropIntoZonesView.TwoZonesScene(
                        viewModel: viewModel, hints: false, dropZoneA: dropZoneA, dropZoneB: dropZoneB)
                } else {
                    scene = DragAndDropIntoZonesView.OneZoneScene(viewModel: viewModel, hints: true, dropZoneA: dropZoneA)
                }

            }
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropIntoZonesView.BaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = viewModel
        return finalScene
    }

}
