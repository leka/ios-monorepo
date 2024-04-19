// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class UIMetrics: ObservableObject {
    // MARK: - Global

    @Published var btnRadius: CGFloat = 10

    // MARK: - Curriculums

    // PillShaped View
    @Published var pillRadius: CGFloat = 70

    // MARK: - Avatars

    @Published var diameter: CGFloat = 125

    // MARK: - Settings

    @Published var verticalPadding: CGFloat = 6

    // MARK: - Tiles

    @Published var tilesRadius: CGFloat = 21
    @Published var tileBtnWidth: CGFloat = 280
    @Published var tilePictoHeightSmall: CGFloat = 80
    @Published var tilePictoHeightMedium: CGFloat = 100
    @Published var tilePictoHeightBig: CGFloat = 120
    @Published var tileContentWidth: CGFloat = 360
    @Published var tileContentPadding: CGFloat = 25
    @Published var tileSize = CGSize(width: 843, height: 327)
}
