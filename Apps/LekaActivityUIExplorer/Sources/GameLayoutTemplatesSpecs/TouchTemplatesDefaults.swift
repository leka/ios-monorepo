// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class DefaultsTemplate: ObservableObject {
    // MARK: - Provided Defaults
    var defaultSize: CGFloat
    var defaultSpacingH: CGFloat
    var defaultSpacingV: CGFloat
    // MARK: - Size
    @Published var playGridBtnSize: CGFloat

    // MARK: - Spacing
    @Published var horizontalCellSpacing: CGFloat
    @Published var verticalCellSpacing: CGFloat

    init(
        defaultSize: CGFloat,
        defaultSpacingH: CGFloat,
        defaultSpacingV: CGFloat,
        playGridBtnSize: CGFloat,
        horizontalCellSpacing: CGFloat,
        verticalCellSpacing: CGFloat
    ) {
        self.defaultSize = defaultSize
        self.defaultSpacingH = defaultSpacingH
        self.defaultSpacingV = defaultSpacingV
        self.playGridBtnSize = playGridBtnSize
        self.horizontalCellSpacing = horizontalCellSpacing
        self.verticalCellSpacing = verticalCellSpacing
    }
}

class DefaultsTemplateOne: DefaultsTemplate {
    init() {
        super
            .init(
                defaultSize: 300,
                defaultSpacingH: 32,
                defaultSpacingV: 32,
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
                defaultSize: 300,
                defaultSpacingH: 32,
                defaultSpacingV: 32,
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
                defaultSize: 260,
                defaultSpacingH: 32,
                defaultSpacingV: 32,
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
                defaultSize: 300,
                defaultSpacingH: 60,
                defaultSpacingV: 32,
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
                defaultSize: 240,
                defaultSpacingH: 200,
                defaultSpacingV: 40,
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
                defaultSize: 200,
                defaultSpacingH: 70,
                defaultSpacingV: 32,
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
                defaultSize: 200,
                defaultSpacingH: 32,
                defaultSpacingV: 32,
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
                defaultSize: 300,
                defaultSpacingH: 100,
                defaultSpacingV: 32,
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
                defaultSize: 300,
                defaultSpacingH: 32,
                defaultSpacingV: 32,
                playGridBtnSize: 0,
                horizontalCellSpacing: 0,
                verticalCellSpacing: 0
            )
    }
}
