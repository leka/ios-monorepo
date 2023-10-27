// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class UIMetrics: ObservableObject {

    // MARK: - Global
    @Published var reg17: Font = .system(size: 17, weight: .regular)
    @Published var semi20: Font = .system(size: 20, weight: .semibold)
    @Published var bold15: Font = .system(size: 15, weight: .bold)
    @Published var bold16: Font = .system(size: 16, weight: .bold)  // Instructions, ProfileSet
    @Published var light24: Font = .system(size: 24, weight: .light)  // sidebar items
    @Published var btnRadius: CGFloat = 10

    // MARK: - Curriculums
    // PillShaped View
    @Published var med16: Font = .system(size: 16, weight: .medium)
    @Published var med12: Font = .system(size: 12, weight: .medium)
    @Published var light14: Font = .system(size: 14, weight: .light)
    @Published var pillRadius: CGFloat = 70

    // Instructions
    @Published var reg18: Font = .system(size: 18, weight: .regular)

    // MARK: - ActivityList Cells
    @Published var reg19: Font = .system(size: 19, weight: .regular)
    @Published var reg15: Font = .system(size: 15, weight: .regular)

    // MARK: - UserData cells (FollowUp)
    @Published var reg12: Font = .system(size: 12, weight: .regular)
    @Published var roundReg14: Font = .system(size: 14, weight: .regular, design: .rounded)
    @Published var reg16: Font = .system(size: 16, weight: .regular)
    @Published var reg14: Font = .system(size: 14, weight: .regular)
    @Published var med14: Font = .system(size: 14, weight: .medium)  // also used wirhin PillShepedView

    // MARK: - Avatars
    @Published var diameter: CGFloat = 125

    // Explorer mode tile
    @Published var semi17: Font = .system(size: 17, weight: .semibold)
    @Published var reg13: Font = .system(size: 13, weight: .regular)

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
