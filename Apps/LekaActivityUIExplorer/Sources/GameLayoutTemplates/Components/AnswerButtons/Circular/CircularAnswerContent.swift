// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CircularAnswerContent: View {

    @EnvironmentObject var gameEngine: GameEngine

    var content: String

    var body: some View {
        Group {
            if gameEngine.answersAreImages {
                Image(content)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Circle()
                    .fill(gameEngine.stringToColor(from: content))
            }
        }
        .clipShape(Circle().inset(by: 2))
    }
}
