// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import DesignKit
import RobotKit
import SwiftUI

extension MusicalInstrumentView.XylophoneView {

    struct TileButtonStyle: ButtonStyle {
        let xyloAttachColor = Color(red: 0.87, green: 0.65, blue: 0.54)
        let defaultMaxTileHeight: Int = 500
        let defaultTileHeightGap: Int = 250
        let defaultTilesScaleFeedback: CGFloat = 0.98
        let defaultTilesRotationFeedback: CGFloat = -1

        let index: Int
        let tileNumber: Int
        let tileWidth: CGFloat

        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .overlay {
                    VStack {
                        Spacer()
                        Circle()
                            .fill(xyloAttachColor)
                            .shadow(
                                color: .black.opacity(0.4),
                                radius: 3, x: 0, y: 3
                            )
                        Spacer()
                        Circle()
                            .fill(xyloAttachColor)
                            .shadow(
                                color: .black.opacity(0.4),
                                radius: 3, x: 0, y: 3
                            )
                        Spacer()
                    }
                    .frame(width: 44)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 7, style: .circular)
                        .stroke(.black.opacity(configuration.isPressed ? 0.3 : 0), lineWidth: 20)
                }
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .circular))
                .frame(width: tileWidth, height: setSizeFromIndex())
                .scaleEffect(
                    configuration.isPressed ? defaultTilesScaleFeedback : 1,
                    anchor: .center
                )
                .rotationEffect(
                    Angle(degrees: configuration.isPressed ? defaultTilesRotationFeedback : 0),
                    anchor: .center
                )
                .shadow(
                    color: .black.opacity(0.4),
                    radius: 3, x: 0, y: 3
                )
        }

        private func setSizeFromIndex() -> CGFloat {
            let sizeDiff = defaultTileHeightGap / tileNumber
            let tileHeight = defaultMaxTileHeight - index * sizeDiff

            return CGFloat(tileHeight)
        }
    }

}

#Preview {
    Button {
        // Nothing to do
    } label: {
        Color(.red)
    }
    .buttonStyle(MusicalInstrumentView.XylophoneView.TileButtonStyle(index: 0, tileNumber: 1, tileWidth: 130))
}
