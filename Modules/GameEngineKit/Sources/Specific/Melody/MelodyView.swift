// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct Tile: Identifiable, Hashable {
    public var id: Int
    var note: String  // Change when MIDI
    var color: Color
}

public let kListOfTiles: [Tile] = [
    Tile(id: 0, note: "do", color: .pink),
    Tile(id: 1, note: "re", color: .red),
    Tile(id: 2, note: "mi", color: .orange),
    Tile(id: 3, note: "fa", color: .yellow),
    Tile(id: 4, note: "sol", color: .green),
    Tile(id: 5, note: "la", color: .blue),
    Tile(id: 6, note: "si", color: .purple),
]

public struct MelodyView: View {
    @ObservedObject private var viewModel: MelodyViewModel

    let defaultTilesSpacing: CGFloat = 16
    let tilesNumber = 7

    public init(gameplay: MelodyGameplay) {
        self.viewModel = MelodyViewModel(gameplay: gameplay)
    }

    public var body: some View {
        VStack {
            ContinuousProgressBar(progress: viewModel.progress)
                .animation(.easeOut, value: viewModel.progress)

            HStack(spacing: defaultTilesSpacing) {
                ForEach(kListOfTiles) { tile in
                    Button {
                        viewModel.onTileTapped(tile: tile)
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
}

struct MelodyView_Previews:
    PreviewProvider
{
    static var previews: some View {
        MelodyView(gameplay: MelodyGameplay(song: kListOfMelodySongsAvailable[0]))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
