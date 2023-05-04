// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesDefaults: ObservableObject {

    // MARK: - Step Instruction Button
    @Published var fontStepInstructionBtn: Font = .system(size: 22, weight: .regular)
    @Published var frameStepInstructionBtn: CGSize = CGSize(width: 640, height: 85)

    // MARK: - Progress Bar
    // Step Markers
    @Published var stepMarkerBorderWidth: CGFloat = 3
    @Published var stepMarkerPadding: CGFloat = 6
    // Progress Bar
    @Published var progressBarHeight: CGFloat = 30
    @Published var progressBarBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.progressBar.swiftUIColor

    // MARK: - GameView Layout
    // Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor
    // Header (ProgressBar + Instruction Button)
    @Published var headerTotalHeight: CGFloat = 155
    @Published var headerSpacing: CGFloat = 20
    @Published var headerPadding: CGFloat = 30
    @Published var semi17: Font = .system(size: 17, weight: .semibold)
    // Answers global properties
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Activity's Instructions Pop-Up
    @Published var reg18: Font = .system(size: 18, weight: .regular)
    @Published var semi20: Font = .system(size: 20, weight: .semibold)
    @Published var bold16: Font = .system(size: 16, weight: .bold)

    // MARK: - Configurators
    @Published var reg15: Font = .system(size: 15, weight: .regular)
    //    @Published var reg13: Font = .system(size: 13, weight: .regular)

    // MARK: - Global properties
    @Published var roundedCorner: CGFloat = 10
    @Published var reg17: Font = .system(size: 17, weight: .regular)
}
