// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class DefaultsTemplate: ObservableObject {
    // MARK: - Game BG
    @Published var activitiesBackgroundColor: Color = LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor

    // MARK: - Answering Buttons
    @Published var playGridBtnSize: CGFloat = 200

    // MARK: - Answers Layouts
    @Published var horizontalCellSpacing: CGFloat = 32
    @Published var verticalCellSpacing: CGFloat = 32

    init(
        activitiesBackgroundColor: Color,
        playGridBtnSize: CGFloat,
        horizontalCellSpacing: CGFloat,
        verticalCellSpacing: CGFloat
    ) {
        self.activitiesBackgroundColor = activitiesBackgroundColor
        self.playGridBtnSize = playGridBtnSize
        self.horizontalCellSpacing = horizontalCellSpacing
        self.verticalCellSpacing = verticalCellSpacing
    }
}

class DefaultsTemplateOne: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 300,
                horizontalCellSpacing: 32,
                verticalCellSpacing: 32
            )
    }
}

class DefaultsTemplateTwo: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 300,
                horizontalCellSpacing: 32,
                verticalCellSpacing: 32
            )
    }
}

class DefaultsTemplateThree: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 260,
                horizontalCellSpacing: 32,
                verticalCellSpacing: 32
            )
    }
}

class DefaultsTemplateThreeInline: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 300,
                horizontalCellSpacing: 60,
                verticalCellSpacing: 32
            )
    }
}

class DefaultsTemplateFour: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 240,
                horizontalCellSpacing: 200,
                verticalCellSpacing: 40
            )
    }
}

class DefaultsTemplateFourInline: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 200,
                horizontalCellSpacing: 70,
                verticalCellSpacing: 32
            )
    }
}

class DefaultsTemplateFive: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 200,
                horizontalCellSpacing: 32,
                verticalCellSpacing: 32
            )
    }
}

class DefaultsTemplateSix: DefaultsTemplate {
    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 240,
                horizontalCellSpacing: 100,
                verticalCellSpacing: 32
            )
    }
}

class XylophoneTemplatesDefaults: DefaultsTemplate {
    // MARK: - Answering Tiles
    @Published var tileWidth: CGFloat = 180
    @Published var tilesSpacing: CGFloat = 32
    @Published var tilesScaleFeedback: CGFloat = 0.98
    @Published var tilesRotationFeedback: Double = -1
    @Published var colors: [Color] = [.green, .purple, .red, .yellow, .blue]

    init() {
        super
            .init(
                activitiesBackgroundColor: LekaActivityUIExplorerAsset.Colors.lightGray.swiftUIColor,
                playGridBtnSize: 0,
                horizontalCellSpacing: 0,
                verticalCellSpacing: 0
            )
    }
}
