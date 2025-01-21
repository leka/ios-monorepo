// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit

extension ExerciseData {
    // MARK: Public

    static let FindTheRightOrderChoicesDefault: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "1st choice"),
        .init(value: "2nd choice"),
        .init(value: "3rd choice"),
        .init(value: "4th choice"),
        .init(value: "5th choice"),
        .init(value: "6th choice"),
    ]

    static let FindTheRightOrderChoicesImages: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "sequencing_dressing_up_1", type: .image, alreadyOrdered: true),
        .init(value: "sequencing_dressing_up_2", type: .image, alreadyOrdered: false),
        .init(value: "sequencing_dressing_up_3", type: .image, alreadyOrdered: false),
        .init(value: "sequencing_dressing_up_4", type: .image, alreadyOrdered: true),
        .init(value: "sequencing_dressing_up_5", type: .image, alreadyOrdered: false),
    ]

    static let FindTheRightOrderChoicesSFSymbols: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "1.circle", type: .sfsymbol, alreadyOrdered: true),
        .init(value: "2.circle", type: .sfsymbol, alreadyOrdered: false),
        .init(value: "3.circle", type: .sfsymbol, alreadyOrdered: false),
        .init(value: "4.circle", type: .sfsymbol, alreadyOrdered: false),
    ]

    static let FindTheRightOrderChoicesEmojis: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "🏊", type: .emoji, alreadyOrdered: false),
        .init(value: "🚴", type: .emoji, alreadyOrdered: false),
        .init(value: "🏃‍♂️", type: .emoji, alreadyOrdered: false),
    ]

    static let FindTheRightOrderChoicesColors: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "red", type: .color, alreadyOrdered: false),
        .init(value: "blue", type: .color, alreadyOrdered: false),
    ]
}
