// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

// MARK: - ExerciseData

extension ExerciseData {
    static let kNoGameplayDefault: [CoordinatorNoGameplayChoiceModel] = [
        .init(value: "Cow"),
        .init(value: "Horse"),
        .init(value: "Duck"),
        .init(value: "Pig"),
        .init(value: "Koala"),
        .init(value: "Duck"),
    ]

    static let kNoGameplayImages: [CoordinatorNoGameplayChoiceModel] = [
        .init(value: "emotion_picto_angry_leka", type: .image),
        .init(value: "emotion_picto_disgust_leka", type: .image),
        .init(value: "emotion_picto_fear_leka", type: .image),
        .init(value: "emotion_picto_joy_leka", type: .image),
        .init(value: "emotion_picto_sad_leka", type: .image),
    ]

    static let kNoGameplaySFSymbols: [CoordinatorNoGameplayChoiceModel] = [
        .init(value: "star", type: .sfsymbol),
        .init(value: "circle", type: .sfsymbol),
        .init(value: "square", type: .sfsymbol),
        .init(value: "triangle", type: .sfsymbol),
    ]

    static let kNoGameplayEmojis: [CoordinatorNoGameplayChoiceModel] = [
        .init(value: "🕺", type: .emoji),
        .init(value: "🚴", type: .emoji),
        .init(value: "🏃‍♂️", type: .emoji),
    ]

    static let kNoGameplayColors: [CoordinatorNoGameplayChoiceModel] = [
        .init(value: "red", type: .color),
        .init(value: "blue", type: .color),
    ]
}
