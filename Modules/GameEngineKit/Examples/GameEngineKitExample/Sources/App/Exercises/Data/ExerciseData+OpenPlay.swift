// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ExerciseData

extension ExerciseData {
    static let kOpenPlayDefault: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "Cow"),
        .init(value: "Horse"),
        .init(value: "Duck"),
        .init(value: "Pig"),
        .init(value: "Koala"),
        .init(value: "Duck"),
    ]

    static let kOpenPlayImages: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "emotion_picto_angry_leka", type: .image),
        .init(value: "emotion_picto_disgust_leka", type: .image),
        .init(value: "emotion_picto_fear_leka", type: .image),
        .init(value: "emotion_picto_joy_leka", type: .image),
        .init(value: "emotion_picto_sad_leka", type: .image),
    ]

    static let kOpenPlaySFSymbols: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "star", type: .sfsymbol),
        .init(value: "circle", type: .sfsymbol),
        .init(value: "square", type: .sfsymbol),
        .init(value: "triangle", type: .sfsymbol),
    ]

    static let kOpenPlayEmojis: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "🕺", type: .emoji),
        .init(value: "🚴", type: .emoji),
        .init(value: "🏃‍♂️", type: .emoji),
    ]

    static let kOpenPlayColors: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "red", type: .color),
        .init(value: "blue", type: .color),
    ]

    static let kOpenPlayWithZonesChoicesDefault: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "😍", type: .emoji, isDropzone: true),
        .init(value: "☹️", type: .emoji, isDropzone: true),
        .init(value: "Whale"),
        .init(value: "Duck"),
        .init(value: "Elephant"),
        .init(value: "Pigeon"),
        .init(value: "Monkey"),
        .init(value: "Chicken"),
    ]

    static let kOpenPlayWithZonesChoicesSFSymbols: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "😍", type: .emoji, isDropzone: true),
        .init(value: "☹️", type: .emoji, isDropzone: true),
        .init(value: "scooter", type: .sfsymbol),
        .init(value: "car", type: .sfsymbol),
        .init(value: "bicycle", type: .sfsymbol),
        .init(value: "sailboat", type: .sfsymbol),
        .init(value: "tram", type: .sfsymbol),
        .init(value: "truck.box", type: .sfsymbol),
    ]

    static let kOpenPlayWithZonesChoicesImages: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "😍", type: .emoji, isDropzone: true),
        .init(value: "☹️", type: .emoji, isDropzone: true),
        .init(value: "pictograms-foods-meals-cup_of_coffee-0184", type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", type: .image),
        .init(value: "pictograms-foods-meals-orange_juice-017C", type: .image),
        .init(value: "pictograms-foods-meals-sandwich-0176", type: .image),
        .init(value: "pictograms-foods-meals-soup-0172", type: .image),
        .init(value: "pictograms-foods-meals-birthday_cake-0173", type: .image),
    ]

    static let kOpenPlayWithZonesChoicesColors: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "😍", type: .emoji, isDropzone: true),
        .init(value: "☹️", type: .emoji, isDropzone: true),
        .init(value: "red", type: .color),
        .init(value: "blue", type: .color),
        .init(value: "green", type: .color),
        .init(value: "purple", type: .color),
        .init(value: "orange", type: .color),
        .init(value: "yellow", type: .color),
    ]

    static let kOpenPlayWithZonesChoicesEmojis: [CoordinatorOpenPlayChoiceModel] = [
        .init(value: "😍", type: .emoji, isDropzone: true),
        .init(value: "☹️", type: .emoji, isDropzone: true),
        .init(value: "🍏", type: .emoji),
        .init(value: "🌮", type: .emoji),
        .init(value: "🍓", type: .emoji),
        .init(value: "🍩", type: .emoji),
        .init(value: "🍊", type: .emoji),
        .init(value: "💩", type: .emoji),
    ]
}
