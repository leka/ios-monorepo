// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct XylophoneTileButtonStyle: ButtonStyle {
    // MARK: Lifecycle

    init(index: Int, tileNumber: Int, tileWidth: CGFloat = 100, isTappable: Bool = true) {
        self.index = index
        self.tileNumber = tileNumber
        self.tileWidth = tileWidth
        self.isTappable = isTappable
    }

    // MARK: Internal

    let xyloAttachColor = Color(red: 0.87, green: 0.65, blue: 0.54)
    let defaultMaxTileHeight: Int = 500
    let defaultTileHeightGap: Int = 250
    let defaultTilesScaleFeedback: CGFloat = 0.98
    let defaultTilesRotationFeedback: CGFloat = -1

    let index: Int
    let tileNumber: Int
    let tileWidth: CGFloat
    let isTappable: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .overlay {
                VStack {
                    Spacer()
                    Circle()
                        .fill(self.xyloAttachColor)
                        .shadow(
                            color: .black.opacity(0.4),
                            radius: 3, x: 0, y: 3
                        )
                    Spacer()
                    Circle()
                        .fill(self.xyloAttachColor)
                        .shadow(
                            color: self.isTappable ? .black.opacity(0.4) : .clear,
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
            .frame(width: self.tileWidth, height: self.setSizeFromIndex())
            .scaleEffect(
                configuration.isPressed ? self.defaultTilesScaleFeedback : 1,
                anchor: .center
            )
            .rotationEffect(
                Angle(degrees: configuration.isPressed ? self.defaultTilesRotationFeedback : 0),
                anchor: .center
            )
            .shadow(
                color: self.isTappable ? .black.opacity(0.4) : .clear,
                radius: 3, x: 0, y: 3
            )
    }

    // MARK: Private

    private func setSizeFromIndex() -> CGFloat {
        let sizeDiff = self.defaultTileHeightGap / self.tileNumber
        let tileHeight = self.defaultMaxTileHeight - self.index * sizeDiff

        return CGFloat(tileHeight)
    }
}

#Preview {
    Button {
        // Nothing to do
    } label: {
        Color(.red)
    }
    .buttonStyle(XylophoneTileButtonStyle(index: 0, tileNumber: 1, tileWidth: 130))
}
