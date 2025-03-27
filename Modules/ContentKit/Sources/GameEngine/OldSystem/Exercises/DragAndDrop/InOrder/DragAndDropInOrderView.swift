// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SpriteKit
import SwiftUI

public struct DragAndDropInOrderView: View {
    // MARK: Lifecycle

    public init(choices: [DragAndDropInOrder.Choice]) {
        _viewModel = StateObject(wrappedValue: ViewModel(choices: choices))
        self.scene = DragAndDropInOrderView.BaseScene(viewModel: self.viewModel)
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DragAndDropInOrder.Payload else {
            logGEK.error("Exercise payload is not .dragAndDropInOrder")
            fatalError("💥 Exercise payload is not .dragAndDropInOrder")
        }

        _viewModel = StateObject(wrappedValue: ViewModel(choices: payload.choices, shared: data))
    }

    // MARK: Public

    public var body: some View {
        GeometryReader { proxy in
            SpriteView(
                scene: self.makeScene(size: proxy.size),
                options: [.allowsTransparency]
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .edgesIgnoringSafeArea(.horizontal)
        .onAppear {
            self.scene = DragAndDropInOrderView.BaseScene(viewModel: self.viewModel)
        }
    }

    // MARK: Private

    @StateObject private var viewModel: ViewModel
    @State private var scene: SKScene = .init()

    private func makeScene(size: CGSize) -> SKScene {
        guard let finalScene = scene as? DragAndDropInOrderView.BaseScene else {
            return SKScene()
        }
        finalScene.size = CGSize(width: size.width, height: size.height)
        finalScene.viewModel = self.viewModel
        return finalScene
    }
}
