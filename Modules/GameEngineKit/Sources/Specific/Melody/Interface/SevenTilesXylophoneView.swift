// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct SevenTilesXylophoneView: View {
    @ObservedObject private var viewModel: SevenTilesXylophoneViewModel

    let defaultTilesSpacing: CGFloat = 16
    let defaultTileColors: [Color] = [.pink, .red, .orange, .yellow, .green, .blue, .purple]

    public init(gameplay: GameplaySelectTheRightMelody) {
        self.viewModel = SevenTilesXylophoneViewModel(gameplay: gameplay)
    }

    public var body: some View {
        VStack {
            ContinuousProgressBar(progress: viewModel.progress)
                .animation(.easeOut, value: viewModel.progress)

            HStack(spacing: defaultTilesSpacing) {
                ForEach(defaultTileColors.indices, id: \.self) { index in
                    Button {
                        viewModel.onTileTapped(tile: defaultTileColors[index])
                    } label: {
                        defaultTileColors[index]
                    }
                    .buttonStyle(XylophoneTileButtonStyle(index: index, tilesNumber: defaultTileColors.count))
                    .compositingGroup()
                }
            }
            .alertWhenRobotIsNeeded()
        }

    }
}
