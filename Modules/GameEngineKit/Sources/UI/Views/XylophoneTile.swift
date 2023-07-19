// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct XylophoneTileButtonStyle: ButtonStyle {
    let defaultMaxTileHeight: Int = 500
    let defaultTileHeightGap: Int = 250
    let defaultTileWidth: CGFloat = 130
    let defaultTilesScaleFeedback: CGFloat = 0.98
    let defaultTilesRotationFeedback: CGFloat = -1

    let index: Int
    let tilesNumber: Int

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .overlay {
                VStack {
                    Spacer()
                    Circle()
                        .fill(.brown)
                    //                        .fill(GameEngineKitAsset.Colors.xyloAttach.swiftUIColor)
                    Spacer()
                    Circle()
                        .fill(.brown)
                    //                        .fill(GameEngineKitAsset.Colors.xyloAttach.swiftUIColor)
                    Spacer()
                }
                .frame(width: 44)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 7, style: .circular)
                    .stroke(.black.opacity(configuration.isPressed ? 0.3 : 0), lineWidth: 20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .circular))
            .frame(width: defaultTileWidth, height: setSizeFromIndex())
            .scaleEffect(
                configuration.isPressed ? defaultTilesScaleFeedback : 1,
                anchor: .center
            )
            .rotationEffect(
                Angle(degrees: configuration.isPressed ? defaultTilesRotationFeedback : 0),
                anchor: .center)
    }

    private func setSizeFromIndex() -> CGFloat {
        let sizeDiff = defaultTileHeightGap / tilesNumber
        let tileHeight = defaultMaxTileHeight - index * sizeDiff

        return CGFloat(tileHeight)
    }
}
