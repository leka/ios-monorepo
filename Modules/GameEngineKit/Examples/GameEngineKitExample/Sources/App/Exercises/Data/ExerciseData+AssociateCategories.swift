// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit

extension ExerciseData {
    // MARK: Public

    static let kAssociateCategoriesChoicesDefault: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "Whale", category: .categoryA),
        .init(value: "Cat", category: .categoryB),
        .init(value: "Dolphin", category: .categoryA),
        .init(value: "Dog", category: .categoryB),
        .init(value: "Shark", category: .categoryA),
        .init(value: "Duck", category: nil),
    ]

    static let kAssociateCategoriesChoicesSFSymbols: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "star", category: .categoryA, type: .sfsymbol),
        .init(value: "circle", category: .categoryB, type: .sfsymbol),
        .init(value: "star", category: .categoryA, type: .sfsymbol),
        .init(value: "circle", category: .categoryB, type: .sfsymbol),
        .init(value: "star", category: .categoryA, type: .sfsymbol),
        .init(value: "square", category: nil, type: .sfsymbol),
    ]

    static let kAssociateCategoriesChoicesEmojis: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "🍉", category: .categoryA, type: .emoji),
        .init(value: "🍏", category: .categoryB, type: .emoji),
        .init(value: "🍉", category: .categoryA, type: .emoji),
        .init(value: "🍏", category: .categoryB, type: .emoji),
        .init(value: "🍉", category: .categoryA, type: .emoji),
        .init(value: "🐶", category: nil, type: .emoji),
    ]

    static let kAssociateCategoriesChoicesColors: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "yellow", category: .categoryB, type: .color),
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "yellow", category: .categoryB, type: .color),
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "blue", category: nil, type: .color),
    ]

    static let kAssociateCategoriesChoicesImages: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "emotion_picto_joy_leka", category: nil, type: .image),
    ]

    static let kAssociateCategoriesWithZonesChoicesDefault: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "Mammals", category: .categoryA, isDropzone: true),
        .init(value: "Birds", category: .categoryB, isDropzone: true),
        .init(value: "Whale", category: .categoryA),
        .init(value: "Duck", category: .categoryB),
        .init(value: "Elephant", category: .categoryA),
        .init(value: "Pigeon", category: .categoryB),
        .init(value: "Monkey", category: .categoryA),
        .init(value: "Chicken", category: .categoryB),
    ]

    static let kAssociateCategoriesWithZonesChoicesSFSymbols: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "cloud.sun", category: .categoryA, type: .sfsymbol, isDropzone: true),
        .init(value: "car.2", category: .categoryB, type: .sfsymbol, isDropzone: true),
        .init(value: "sun.max", category: .categoryA, type: .sfsymbol),
        .init(value: "car", category: .categoryB, type: .sfsymbol),
        .init(value: "sun.rain", category: .categoryA, type: .sfsymbol),
        .init(value: "car.side", category: .categoryB, type: .sfsymbol),
        .init(value: "cloud.snow", category: .categoryA, type: .sfsymbol),
        .init(value: "truck.box", category: .categoryB, type: .sfsymbol),
    ]

    static let kAssociateCategoriesWithZonesChoicesImages: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "dropzone_bathroom", category: .categoryA, type: .image, isDropzone: true),
        .init(value: "dropzone_bedroom", category: .categoryB, type: .image, isDropzone: true),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-foods-vegetables-broccoli_green-00E5", category: nil, type: .image),
    ]

    static let kAssociateCategoriesWithZonesChoicesColors: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "red", category: .categoryA, type: .color, isDropzone: true),
        .init(value: "blue", category: .categoryB, type: .color, isDropzone: true),
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "blue", category: .categoryB, type: .color),
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "blue", category: .categoryB, type: .color),
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "yellow", category: nil, type: .color),
    ]

    static let kAssociateCategoriesWithZonesChoicesEmojis: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "🍉", category: .categoryA, type: .emoji, isDropzone: true),
        .init(value: "🐵", category: .categoryB, type: .emoji, isDropzone: true),
        .init(value: "🍏", category: .categoryA, type: .emoji),
        .init(value: "🐄", category: .categoryB, type: .emoji),
        .init(value: "🍓", category: .categoryA, type: .emoji),
        .init(value: "🦏", category: .categoryB, type: .emoji),
        .init(value: "🍊", category: .categoryA, type: .emoji),
        .init(value: "🎺", category: nil, type: .emoji),
    ]
}
