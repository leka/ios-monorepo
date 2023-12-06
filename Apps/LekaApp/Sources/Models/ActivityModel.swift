// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - ActivityCell

struct ActivityCell: Identifiable {
    var id = UUID()
    var img: String
    var texts: [String]
}

// MARK: - Instructions

struct Instructions: Codable {
    var instructions: LocalizedContent

    init(instructions: LocalizedContent = LocalizedContent()) {
        self.instructions = instructions
    }
}

// MARK: - Activity

struct Activity: Codable {
    enum CodingKeys: String, CodingKey {
        case title, steps
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
    var steps: [Step]

    init(
        id: String = "",
        title: LocalizedContent = LocalizedContent(),
        short: LocalizedContent = LocalizedContent(),
        activityType: String? = "touch_to_select",
        stepsAmount: Int = 0,
        isRandom: Bool = false,
        numberOfImages: Int = 0,
        randomImagePosition: Bool = false,
        steps: [Step] = []
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
}

// MARK: - Step

// Step conforms to Equatable because steps are compared when randomized
struct Step: Codable, Equatable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        lhs.instruction == rhs.instruction
    }

    enum CodingKeys: String, CodingKey {
        case instruction, images, sound
        case correctAnswer = "correct_answer"
    }

    var instruction: LocalizedContent
    var correctAnswer: String
    var images: [String]
    var sound: [String]?

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
}
