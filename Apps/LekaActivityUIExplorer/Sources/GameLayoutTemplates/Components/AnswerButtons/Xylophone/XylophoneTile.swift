// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct XylophoneTile: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @Binding var color: Color

    var body: some View {
        Button(
            action: {
                // Play Sound HERE
            }, label: { color }
        )
        .buttonStyle(XylophoneTileButtonStyle(color: color))
        .compositingGroup()
    }
}
