// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import RobotKit
import SwiftUI

public struct XylophoneTile: Identifiable {
    public var id: Int
    var noteNumber: MIDINoteNumber
    var color: Robot.Color
}

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
    let tileNumber = 7

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
                        tile.color.screen
                    }
                    .buttonStyle(
                        MusicalInstrumentView.XylophoneView.TileButtonStyle(
                            index: tile.id, tileNumber: tileNumber, tileWidth: 130)
                    )
                    .compositingGroup()
                }
            }
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
