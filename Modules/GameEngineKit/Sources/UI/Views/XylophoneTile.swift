// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct XylophoneTileButtonStyle: ButtonStyle {
    let xyloAttachColor = Color(red: 0.87, green: 0.65, blue: 0.54)
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
                        .fill(xyloAttachColor)
                    Spacer()
                    Circle()
                        .fill(xyloAttachColor)
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

struct XylophoneTileButtonStyle_Previews:
    PreviewProvider
{
    static var previews: some View {
        Button {
            // Nothing to do
        } label: {
            Color(.red)
        }
        .buttonStyle(XylophoneTileButtonStyle(index: 0, tilesNumber: 1))
    }
}
