// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

public struct BasketOneChoiceView: View {
    @ObservedObject private var viewModel: GenericViewModel
//    let horizontalSpacing: CGFloat = 32
//    let answerSize: CGFloat = 300

    public init(gameplay: any GameplayProtocol) {
        self.viewModel = GenericViewModel(gameplay: gameplay)
    }

    public var body: some View {
//        HStack(spacing: horizontalSpacing) {
//            let choice = viewModel.choices[0]
//
//            ChoiceView(choice: choice, size: answerSize)
//                .onTapGesture {
//                    viewModel.onChoiceTapped(choice: choice)
//                }
//        }
        DragAndDropHostView(
            viewModel: viewModel,
            scene: DragAndDropOneAreaOneChoiceScene()
        )
    }
}
