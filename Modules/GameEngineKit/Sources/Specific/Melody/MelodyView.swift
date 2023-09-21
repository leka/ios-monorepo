// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

public let kListOfTiles: [XylophoneTile] = [
    XylophoneTile(id: 0, noteNumber: 24, color: DesignKitAsset.Colors.lekaActivityPink.swiftUIColor),
    XylophoneTile(id: 1, noteNumber: 26, color: DesignKitAsset.Colors.lekaActivityRed.swiftUIColor),
    XylophoneTile(id: 2, noteNumber: 28, color: DesignKitAsset.Colors.lekaActivityOrange.swiftUIColor),
    XylophoneTile(id: 3, noteNumber: 29, color: DesignKitAsset.Colors.lekaActivityYellow.swiftUIColor),
    XylophoneTile(id: 4, noteNumber: 31, color: DesignKitAsset.Colors.lekaActivityGreen.swiftUIColor),
    XylophoneTile(id: 5, noteNumber: 33, color: DesignKitAsset.Colors.lekaActivityBlue.swiftUIColor),
    XylophoneTile(id: 6, noteNumber: 35, color: DesignKitAsset.Colors.lekaActivityPurple.swiftUIColor),
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
