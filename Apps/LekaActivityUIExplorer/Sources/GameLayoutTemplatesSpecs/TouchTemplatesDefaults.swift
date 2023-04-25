// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class DefaultsTemplateOne: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class DefaultsTemplateTwo: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class DefaultsTemplateThree: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class DefaultsTemplateThreeInline: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class DefaultsTemplateFour: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class DefaultsTemplateFourInline: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class DefaultsTemplateFive: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class DefaultsTemplateSix: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridBtnTrimLineWidth: CGFloat = 6

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32
}

class XylophoneTemplatesDefaults: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Tiles
    @Published var xylophoneTileWidth: CGFloat = 180
    @Published var xylophoneTilesSpacing: CGFloat = 32
    @Published var xylophoneTilesScaleFeedback: CGFloat = 0.98
    @Published var xylophoneTilesRotationFeedback: Double = -1
    //    @Published var colors: [Color] = [.green, .purple, .red, .yellow, .blue]
}
