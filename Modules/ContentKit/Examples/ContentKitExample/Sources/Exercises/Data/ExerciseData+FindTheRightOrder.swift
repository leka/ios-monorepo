// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit

extension ExerciseData {
    // MARK: Public

    static let kFindTheRightOrderChoicesDefault: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "1st choice"),
        .init(value: "2nd choice"),
        .init(value: "3rd choice"),
        .init(value: "4th choice"),
        .init(value: "5th choice"),
        .init(value: "6th choice"),
    ]

    static let kFindTheRightOrderChoicesImages: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "sequencing_dressing_up_1", type: .image, alreadyOrdered: true),
        .init(value: "sequencing_dressing_up_2", type: .image, alreadyOrdered: false),
        .init(value: "sequencing_dressing_up_3", type: .image, alreadyOrdered: false),
        .init(value: "sequencing_dressing_up_4", type: .image, alreadyOrdered: true),
        .init(value: "sequencing_dressing_up_5", type: .image, alreadyOrdered: false),
    ]

    static let kFindTheRightOrderChoicesSFSymbols: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "1.circle", type: .sfsymbol, alreadyOrdered: true),
        .init(value: "2.circle", type: .sfsymbol, alreadyOrdered: false),
        .init(value: "3.circle", type: .sfsymbol, alreadyOrdered: false),
        .init(value: "4.circle", type: .sfsymbol, alreadyOrdered: false),
    ]

    static let kFindTheRightOrderChoicesEmojis: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "🏊", type: .emoji, alreadyOrdered: false),
        .init(value: "🚴", type: .emoji, alreadyOrdered: false),
        .init(value: "🏃‍♂️", type: .emoji, alreadyOrdered: false),
    ]

    static let kFindTheRightOrderChoicesColors: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "red", type: .color, alreadyOrdered: false),
        .init(value: "blue", type: .color, alreadyOrdered: false),
    ]
}
