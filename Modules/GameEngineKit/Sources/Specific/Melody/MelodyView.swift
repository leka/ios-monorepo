// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public let kListOfTiles: [XylophoneTile] = [
    XylophoneTile(id: 0, noteNumber: 24, color: .pink),
    XylophoneTile(id: 1, noteNumber: 26, color: .red),
    XylophoneTile(id: 2, noteNumber: 28, color: .orange),
    XylophoneTile(id: 3, noteNumber: 29, color: .yellow),
    XylophoneTile(id: 4, noteNumber: 31, color: .green),
    XylophoneTile(id: 5, noteNumber: 33, color: .blue),
    XylophoneTile(id: 6, noteNumber: 35, color: .purple),
]

public struct MelodyView: View {
    @ObservedObject private var viewModel: MelodyViewModel

    let defaultTilesSpacing: CGFloat = 16
    let tilesNumber = 7

    public init(gameplay: MelodyGameplay) {
        self.viewModel = MelodyViewModel(gameplay: gameplay)
    }

    public var body: some View {
        VStack(spacing: 50) {
            ContinuousProgressBar(progress: viewModel.progress)
                .animation(.easeOut, value: viewModel.progress)
                .padding(.horizontal)

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
