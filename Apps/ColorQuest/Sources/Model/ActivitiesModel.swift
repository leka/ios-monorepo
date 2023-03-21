//
//  ActivitiesModel.swift
//  Leka Emotion
//
//  Created by Mathieu Jeannot on 24/5/22.
//

import Foundation

struct Activity: Codable {
    enum CodingKeys: String, CodingKey {
        case title, steps
        case short = "short_title"
        case id = "uuid"
        case activityType = "type"
        case stepsAmount = "number_of_steps"
        case isRandom = "random_steps"
        case numberOfElements = "number_of_elements_per_step"
        case randomElementPosition = "random_element_position"
    }

    var id: String
    var title: LocalizedContent
    var short: LocalizedContent
    var activityType: String?
    var stepsAmount: Int
    var isRandom: Bool
    var numberOfElements: Int
    var randomElementPosition: Bool?
    var steps: [Step]

    init(id: String = "",
         title: LocalizedContent = LocalizedContent(),
         short: LocalizedContent = LocalizedContent(),
         activityType: String? = "touch_to_select",
         stepsAmount: Int = 0,
         isRandom: Bool = false,
         numberOfElements: Int = 0,
         randomElementPosition: Bool = false,
         steps: [Step] = []
    ) {
        self.id = id
        self.title = title
        self.short = short
        self.activityType = activityType
        self.stepsAmount = stepsAmount
        self.isRandom = isRandom
        self.numberOfElements = numberOfElements
        self.randomElementPosition = randomElementPosition
        self.steps = steps
    }
}

// Step conforms to Equatable because steps are compared when randomized
struct Step: Codable, Equatable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.instruction == rhs.instruction
    }
    enum CodingKeys: String, CodingKey {
        case instruction, sound
        case correctAnswer = "correct_answer"
		case elements = "colors_diplayed_on_screen"
    }
    var instruction: LocalizedContent
    var correctAnswer: String
    var elements: [String]
    var sound: [String]?

    init(instruction: LocalizedContent = LocalizedContent(),
         correctAnswer: String = "",
		 elements: [String] = [],
         sound: [String]? = []
    ) {
        self.instruction = instruction
        self.correctAnswer = correctAnswer
        self.elements = elements
        self.sound = sound
    }
}
