// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

public class BaseDefaults: ObservableObject {

    // MARK: - Provided Defaults

    var defaultAnswerSize: CGFloat
    var defaultHorizontalSpacing: CGFloat
    var defaultVerticalSpacing: CGFloat

    // MARK: - Custom

    @Published var customAnswerSize: CGFloat
    @Published var customHorizontalSpacing: CGFloat
    @Published var customVerticalSpacing: CGFloat

    init(
        defaultAnswerSize: CGFloat,
        defaultHorizontalSpacing: CGFloat,
        defaultVerticalSpacing: CGFloat
    ) {
        self.defaultAnswerSize = defaultAnswerSize
        self.defaultHorizontalSpacing = defaultHorizontalSpacing
        self.defaultVerticalSpacing = defaultVerticalSpacing

        self.customAnswerSize = defaultAnswerSize
        self.customHorizontalSpacing = defaultHorizontalSpacing
        self.customVerticalSpacing = defaultVerticalSpacing
    }

}

public class ListenThenTouchToSelectDefaults: BaseDefaults {
    var defaultListenButtonSize: CGFloat

    @Published var customListenButtonSize: CGFloat

    init(
        defaultAnswerSize: CGFloat,
        defaultHorizontalSpacing: CGFloat,
        defaultVerticalSpacing: CGFloat,
        defaultListenButtonSize: CGFloat
    ) {
        self.defaultListenButtonSize = defaultListenButtonSize
        self.customListenButtonSize = defaultListenButtonSize
        super
            .init(
                defaultAnswerSize: defaultAnswerSize,
                defaultHorizontalSpacing: defaultHorizontalSpacing,
                defaultVerticalSpacing: defaultVerticalSpacing
            )
    }

}

public class XylophoneDefaults: BaseDefaults {
    var defaultTileWidth: CGFloat
    var defaultTilesSpacing: CGFloat
    var defaultTilesScaleFeedback: CGFloat
    var defaultTilesRotationFeedback: Double
    var defaultTileColors: [Color]
    // MARK: - Answering Tiles
    @Published var customTileWidth: CGFloat
    @Published var customTilesSpacing: CGFloat
    @Published var customTilesScaleFeedback: CGFloat
    @Published var customTilesRotationFeedback: Double
    @Published var customTileColors: [Color]

    init(
        defaultTileWidth: CGFloat,
        defaultTilesSpacing: CGFloat,
        defaultTilesScaleFeedback: CGFloat,
        defaultTilesRotationFeedback: Double,
        defaultTileColors: [Color]
    ) {
        self.defaultTileWidth = defaultTileWidth
        self.defaultTilesSpacing = defaultTilesSpacing
        self.defaultTilesScaleFeedback = defaultTilesScaleFeedback
        self.defaultTilesRotationFeedback = defaultTilesRotationFeedback
        self.defaultTileColors = defaultTileColors

        self.customTileWidth = defaultTileWidth
        self.customTilesSpacing = defaultTilesSpacing
        self.customTilesScaleFeedback = defaultTilesScaleFeedback
        self.customTilesRotationFeedback = defaultTilesRotationFeedback
        self.customTileColors = defaultTileColors
        super
            .init(
                defaultAnswerSize: 0,
                defaultHorizontalSpacing: 0,
                defaultVerticalSpacing: 0
            )
    }
}

// swiftlint:disable identifier_name

public enum TouchToSelect {
    public static let one = BaseDefaults(
        defaultAnswerSize: 300, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32)
    public static let two = BaseDefaults(
        defaultAnswerSize: 300, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32)
    public static let three = BaseDefaults(
        defaultAnswerSize: 260, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32)
    public static let threeInline = BaseDefaults(
        defaultAnswerSize: 300, defaultHorizontalSpacing: 60, defaultVerticalSpacing: 32)
    public static let four = BaseDefaults(
        defaultAnswerSize: 240, defaultHorizontalSpacing: 200, defaultVerticalSpacing: 40)
    public static let fourInline = BaseDefaults(
        defaultAnswerSize: 200, defaultHorizontalSpacing: 70, defaultVerticalSpacing: 32)
    public static let five = BaseDefaults(
        defaultAnswerSize: 200, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32)
    public static let six = BaseDefaults(
        defaultAnswerSize: 300, defaultHorizontalSpacing: 100, defaultVerticalSpacing: 32)
}

public enum ListenThenTouchToSelect {
    public static let one = ListenThenTouchToSelectDefaults(
        defaultAnswerSize: 300, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32, defaultListenButtonSize: 200)
    public static let two = ListenThenTouchToSelectDefaults(
        defaultAnswerSize: 300, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32, defaultListenButtonSize: 200)
    public static let three = ListenThenTouchToSelectDefaults(
        defaultAnswerSize: 230, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32, defaultListenButtonSize: 200)
    public static let threeInline = ListenThenTouchToSelectDefaults(
        defaultAnswerSize: 220, defaultHorizontalSpacing: 60, defaultVerticalSpacing: 32, defaultListenButtonSize: 200)
    public static let four = ListenThenTouchToSelectDefaults(
        defaultAnswerSize: 240, defaultHorizontalSpacing: 200, defaultVerticalSpacing: 40, defaultListenButtonSize: 200)
    public static let fourInline = ListenThenTouchToSelectDefaults(
        defaultAnswerSize: 160, defaultHorizontalSpacing: 50, defaultVerticalSpacing: 32, defaultListenButtonSize: 200)
    public static let six = ListenThenTouchToSelectDefaults(
        defaultAnswerSize: 200, defaultHorizontalSpacing: 80, defaultVerticalSpacing: 32, defaultListenButtonSize: 200)
}

public enum ColorQuest {
    public static let one = BaseDefaults(
        defaultAnswerSize: 500, defaultHorizontalSpacing: 32, defaultVerticalSpacing: 32)
    public static let two = BaseDefaults(
        defaultAnswerSize: 350, defaultHorizontalSpacing: 70, defaultVerticalSpacing: 32)
    public static let three = BaseDefaults(
        defaultAnswerSize: 260, defaultHorizontalSpacing: 70, defaultVerticalSpacing: 32)
}

public enum Misc {
    public static let xylophone = XylophoneDefaults(
        defaultTileWidth: 180, defaultTilesSpacing: 32, defaultTilesScaleFeedback: 0.98,
        defaultTilesRotationFeedback: -1, defaultTileColors: [.green, .purple, .red, .yellow, .blue])
}

public enum Remote {
    // ? no defaults needed
    public static let standard: BaseDefaults? = nil
    public static let arrow: BaseDefaults? = nil
}

public enum DragAndDrop {
    // ? no defaults needed
    public static let basket: BaseDefaults? = nil
}

public enum DanceFreeze {
    // ? no defaults needed
    public static let standard: BaseDefaults? = nil
}

public enum HideAndSeek {
    // ? no defaults needed
    public static let standard: BaseDefaults? = nil
}

// swiftlint:enable identifier_name
