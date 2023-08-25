// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import DesignKit
import SwiftUI

public struct XylophoneTile: Identifiable, Hashable {
    public var id: Int
    var noteNumber: MIDINoteNumber
    var color: Color
}

let kListOfXylophoneTiles: [XylophoneTile] = [
    XylophoneTile(id: 0, noteNumber: 24, color: .green),
    XylophoneTile(id: 1, noteNumber: 26, color: .purple),
    XylophoneTile(id: 2, noteNumber: 28, color: .red),
    XylophoneTile(id: 3, noteNumber: 29, color: .yellow),
    XylophoneTile(id: 4, noteNumber: 31, color: .blue),
]

public struct XylophoneView: View {
    @StateObject var xyloPlayer = MIDIPlayer(name: "Xylophone", samples: xyloSamples)
    let defaultTilesSpacing: CGFloat = 40
    let tilesNumber = kListOfXylophoneTiles.count

    public init() {
        // Nothing to do
    }

    public var body: some View {
        HStack(spacing: defaultTilesSpacing) {
            ForEach(kListOfXylophoneTiles) { tile in
                Button {
                    xyloPlayer.noteOn(number: tile.noteNumber)
                } label: {
                    tile.color
                }
                .buttonStyle(XylophoneTileButtonStyle(index: tile.id, tilesNumber: tilesNumber))
                .compositingGroup()
            }
        }
        .alertWhenRobotIsNeeded()
    }
}

struct XylophoneView_Previews:
    PreviewProvider
{
    static var previews: some View {
        XylophoneView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
