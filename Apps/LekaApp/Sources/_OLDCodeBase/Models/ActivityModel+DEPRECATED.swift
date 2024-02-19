// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - ActivityCellDeprecated

struct ActivityCellDeprecated: Identifiable {
    var id = UUID()
    var img: String
    var texts: [String]
}

// MARK: - InstructionsDeprecated

struct InstructionsDeprecated: Codable {
    // MARK: Lifecycle

    init(instructions: LocalizedContent = LocalizedContent()) {
        self.instructions = instructions
    }

    // MARK: Internal

    var instructions: LocalizedContent
}

// MARK: - ActivityDeprecated

struct ActivityDeprecated: Codable {
    // MARK: Lifecycle

    init(
        id: String = "",
        title: LocalizedContent = LocalizedContent(),
        short: LocalizedContent = LocalizedContent(),
        activityType: String? = "touch_to_select",
        stepsAmount: Int = 0,
        isRandom: Bool = false,
        numberOfImages: Int = 0,
        randomImagePosition: Bool = false,
        steps: [StepDeprecated] = []
    ) {
        self.id = id
        self.title = title
        self.short = short
        self.activityType = activityType
        self.stepsAmount = stepsAmount
        self.isRandom = isRandom
        self.numberOfImages = numberOfImages
        self.randomImagePosition = randomImagePosition
        self.steps = steps
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case title
        case steps
        case short = "short_title"
        case id = "uuid"
        case activityType = "type"
        case stepsAmount = "number_of_steps"
        case isRandom = "random_steps"
        case numberOfImages = "number_of_images_per_step"
        case randomImagePosition = "random_image_position"
    }

    var id: String
    var title: LocalizedContent
    var short: LocalizedContent
    var activityType: String?
    var stepsAmount: Int
    var isRandom: Bool
    var numberOfImages: Int
    var randomImagePosition: Bool
    var steps: [StepDeprecated]
}

// MARK: - StepDeprecated

// Step conforms to Equatable because steps are compared when randomized
struct StepDeprecated: Codable, Equatable {
    // MARK: Lifecycle

    init(
        instruction: LocalizedContent = LocalizedContent(),
        correctAnswer: String = "",
        images: [String] = [],
        sound: [String]? = []
    ) {
        self.instruction = instruction
        self.correctAnswer = correctAnswer
        self.images = images
        self.sound = sound
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case instruction
        case images
        case sound
        case correctAnswer = "correct_answer"
    }

    var instruction: LocalizedContent
    var correctAnswer: String
    var images: [String]
    var sound: [String]?

    static func == (lhs: StepDeprecated, rhs: StepDeprecated) -> Bool {
        lhs.instruction == rhs.instruction
    }
}
