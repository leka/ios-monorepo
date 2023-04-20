// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesDefaults: ObservableObject {

    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = Color("GLT_BackgroundColor_LightGray")

    // MARK: - Step Instruction Button
    @Published var fontStepInstructionBtn: Font = .system(size: 22, weight: .regular)
    @Published var frameStepInstructionBtn: CGSize = CGSize(width: 640, height: 85)

    // MARK: - Progress Bar
    // Step Markers
    @Published var stepMarkerBorderWidth: CGFloat = 3
    @Published var stepMarkerPadding: CGFloat = 6
    // Progress Bar
    @Published var progressBarHeight: CGFloat = 30
    @Published var progressBarBackgroundColor: Color = Color("progressBar")

    // MARK: - GameView Layout
    // Header (ProgressBar + Instruction Button)
    @Published var headerTotalHeight: CGFloat = 155
    @Published var headerSpacing: CGFloat = 40
    @Published var headerPadding: CGFloat = 30
    @Published var semi17: Font = .system(size: 17, weight: .semibold)

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6
    // Xylophone
    @Published var xylophoneTileWidth: CGFloat = 180
    @Published var xylophoneTilesSpacing: CGFloat = 32
    @Published var xylophoneTilesScaleFeedback: CGFloat = 0.98
    @Published var xylophoneTilesRotationFeedback: Double = -1

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32

    // MARK: - Activity's Instructions Pop-Up
    @Published var reg18: Font = .system(size: 18, weight: .regular)
    @Published var semi20: Font = .system(size: 20, weight: .semibold)
    @Published var bold16: Font = .system(size: 16, weight: .bold)

    // MARK: - Configurators
    @Published var reg15: Font = .system(size: 15, weight: .regular)
    @Published var reg13: Font = .system(size: 13, weight: .regular)

    // MARK: - Global properties
    @Published var roundedCorner: CGFloat = 10
    @Published var reg17: Font = .system(size: 17, weight: .regular)
}
