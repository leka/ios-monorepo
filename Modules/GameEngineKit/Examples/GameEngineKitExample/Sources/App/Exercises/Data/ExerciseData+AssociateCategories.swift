// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit

extension ExerciseData {
    // MARK: Public

    static let AssociateCategoriesChoicesDefault: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        .init(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        .init(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        .init(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        .init(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        .init(value: "Maison", category: nil, type: .text),
    ]

    static let AssociateCategoriesChoicesEmojis: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "🍉", category: .categoryA, type: .emoji),
        .init(value: "🍏", category: .categoryB, type: .emoji),
        .init(value: "🍉", category: .categoryA, type: .emoji),
        .init(value: "🍏", category: .categoryB, type: .emoji),
        .init(value: "🍉", category: .categoryA, type: .emoji),
        .init(value: "🐶", category: nil, type: .emoji),
    ]

    static let AssociateCategoriesChoicesColors: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "yellow", category: .categoryB, type: .color),
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "yellow", category: .categoryB, type: .color),
        .init(value: "red", category: .categoryA, type: .color),
        .init(value: "blue", category: nil, type: .color),
    ]

    static let AssociateCategoriesChoicesImages: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "Maison", category: nil, type: .text),
    ]

    static let AssociateCategoriesWithZonesChoicesDefault: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "sun", category: .categoryA, type: .text),
        .init(value: "car", category: .categoryB, type: .text),
        .init(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        .init(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        .init(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        .init(value: "car.rear.fill", category: .categoryB, type: .sfsymbol),
        .init(value: "sun.max.fill", category: .categoryA, type: .sfsymbol),
        .init(value: "Maison", category: nil, type: .text),
    ]

    static let AssociateCategoriesWithZonesChoicesImages: [CoordinatorAssociateCategoriesChoiceModel] = [
        .init(value: "dropzone_bathroom", category: .categoryA, type: .image),
        .init(value: "dropzone_bedroom", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "pictograms-animals-arctic-penguin_yellow-0088", category: .categoryB, type: .image),
        .init(value: "pictograms-weather-sun_yellow-0106", category: .categoryA, type: .image),
        .init(value: "Maison", category: nil, type: .text),
    ]
}
