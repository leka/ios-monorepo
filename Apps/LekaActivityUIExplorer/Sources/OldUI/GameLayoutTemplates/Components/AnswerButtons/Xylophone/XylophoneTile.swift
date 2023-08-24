// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct XylophoneTile: View {
    @ObservedObject var xylophoneDefaults: XylophoneDefaults

    var index: Int

    var body: some View {
        Button {
            print("Play music")
        } label: {
            xylophoneDefaults.customTileColors[index]
        }
        .buttonStyle(XylophoneTileButtonStyle(xylophoneDefaults: xylophoneDefaults, index: index))
        .compositingGroup()
    }
}
