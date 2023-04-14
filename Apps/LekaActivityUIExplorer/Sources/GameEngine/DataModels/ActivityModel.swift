//
//  ActivityModel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 9/2/23.
//

import SwiftUI

struct Activity: Codable, Equatable, Identifiable {

    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case title, instructions
        case short = "short_title"
        case id = "uuid"
        case activityType = "type"
        case stepsAmount = "number_of_steps"
        case isRandom = "random_steps"
        case numberOfImages = "number_of_images_per_step"
        case randomAnswerPositions = "random_image_position"
        case stepSequence = "steps"
    }

    var id: UUID
    var title: LocalizedContent
    var short: LocalizedContent
    var instructions: LocalizedContent
    var activityType: String?
    var stepsAmount: Int
    var isRandom: Bool
    var numberOfImages: Int
    var randomAnswerPositions: Bool
    var stepSequence: [[Step]]

    init(
        id: UUID = UUID(),
        title: LocalizedContent = LocalizedContent(),
        short: LocalizedContent = LocalizedContent(),
        instructions: LocalizedContent = LocalizedContent(),
        activityType: String? = "touch_to_select",
        stepsAmount: Int = 10,
        isRandom: Bool = false,
        numberOfImages: Int = 0,  // this should be in the Step Type
        randomAnswerPositions: Bool = false,
        stepSequence: [[Step]] = [[]]
    ) {
        self.id = id
        self.title = title
        self.short = short
        self.instructions = instructions
        self.activityType = activityType
        self.stepsAmount = stepsAmount
        self.isRandom = isRandom
        self.numberOfImages = numberOfImages
        self.randomAnswerPositions = randomAnswerPositions
        self.stepSequence = stepSequence
    }
}

// Step conforms to Equatable because steps are compared when randomized
struct Step: Codable, Equatable, Identifiable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.instruction == rhs.instruction
    }

    enum CodingKeys: String, CodingKey {
        case instruction, id, sound
        case allAnswers = "images"
        case correctAnswer = "correct_answer"
    }

    var id: UUID
    var instruction: LocalizedContent
    var correctAnswer: String
    var allAnswers: [String]
    var sound: [String]?

    init(
        id: UUID = UUID(),
        instruction: LocalizedContent = LocalizedContent(),
        correctAnswer: String = "",
        allAnswers: [String] = [],
        sound: [String]? = []
    ) {
        self.id = id
        self.instruction = instruction
        self.correctAnswer = correctAnswer
        self.allAnswers = allAnswers
        self.sound = sound
    }
}
