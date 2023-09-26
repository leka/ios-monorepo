// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct DragAndDropOneAreaOneChoiceView: View {
    @ObservedObject private var viewModel: GenericViewModel
    let contexts: [ContextModel]

    public init(gameplay: any GameplayProtocol, contexts: [ContextModel]) {
        self.viewModel = GenericViewModel(gameplay: gameplay)
        self.contexts = contexts
    }

    public var body: some View {
        DragAndDropHostView(
            scene: DragAndDropOneAreaOneChoiceScene(viewModel: viewModel, contexts: contexts)
        )
    }
}
