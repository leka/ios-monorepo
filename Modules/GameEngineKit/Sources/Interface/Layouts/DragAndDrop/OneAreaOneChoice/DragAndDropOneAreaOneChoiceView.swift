// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct DragAndDropOneAreaOneChoiceView: View {
    @ObservedObject private var viewModel: GenericViewModel
    let context: ContextModel
    //    let horizontalSpacing: CGFloat = 32
    //    let answerSize: CGFloat = 300

    public init(gameplay: any GameplayProtocol, context: ContextModel) {
        self.viewModel = GenericViewModel(gameplay: gameplay)
        self.context = context
    }

    public var body: some View {
        DragAndDropHostView(
            scene: DragAndDropOneAreaOneChoiceScene(viewModel: viewModel, contexts: [context])
        )
    }
}
