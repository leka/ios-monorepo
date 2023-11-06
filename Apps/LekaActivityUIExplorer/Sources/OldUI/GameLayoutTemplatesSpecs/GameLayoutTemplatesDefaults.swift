// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesDefaults: ObservableObject {

    // MARK: - Progress Bar
    @Published var progressBarHeight: CGFloat = 30
    @Published var progressBarBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.progressBar.swiftUIColor

    // MARK: - GameView Layout
    // Header (ProgressBar + Instruction Button)
    //    @Published var headerTotalHeight: CGFloat = 155
    //    @Published var headerSpacing: CGFloat = 20
    //    @Published var headerPadding: CGFloat = 30
    @Published var semi17: Font = .system(size: 17, weight: .semibold)
    // Answers global properties
    @Published var playGridBtnTrimLineWidth: CGFloat = 6
    // Lottie Screens
    @Published var motivatorScale: CGFloat = 1.2
    @Published var endAnimTextsSpacing: CGFloat = 40
    @Published var endAnimFontSize: CGFloat = 30
    @Published var endAnimFontWeight: Font.Weight = .black
    @Published var endAnimFontDesign: Font.Design = .rounded
    @Published var endAnimDuration: Double = 0.6
    @Published var endAnimDelayTop: Double = 1.2
    @Published var endAnimDelayBottom: Double = 1.0
    @Published var endAnimBtnDuration: Double = 0.25
    @Published var endAnimGameOverBtnDelay: Double = 1.6
    @Published var endAnimReplayBtnDelay: Double = 1.7
    @Published var endAnimBtnPadding: CGFloat = 80

    // MARK: - Activity's Instructions Pop-Up
    //    @Published var reg18: Font = .system(size: 18, weight: .regular)
    //    @Published var semi20: Font = .system(size: 20, weight: .semibold)
    //    @Published var bold16: Font = .system(size: 16, weight: .bold)

    // MARK: - Configurators
    //    @Published var reg15: Font = .system(size: 15, weight: .regular)
    //    @Published var reg13: Font = .system(size: 13, weight: .regular)

    // MARK: - Global properties
    @Published var roundedCorner: CGFloat = 10
    @Published var reg17: Font = .system(size: 17, weight: .regular)
}
