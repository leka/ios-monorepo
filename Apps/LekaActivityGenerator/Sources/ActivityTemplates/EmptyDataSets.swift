//
//  EmptyDataSets.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 3/4/23.
//

import Foundation

// Model to start from
class EmptyDataSets: ObservableObject {

	func makeEmptyActivity() -> Activity {
		return Activity(
			id: UUID(),
			title: emptyTitle,
			short: emptyShort,
			instructions: emptyInstructions(),
			activityType: "touch_to_select",
			stepsAmount: 2,
			isRandom: false,
			numberOfImages: 0,
			randomAnswerPositions: false,
			stepSequence: makeEmptyStepArray())
	}

	// MARK: - Empty Activity Values
	var emptyTitle = LocalizedContent(enUS: "", frFR: "")

	var emptyShort = LocalizedContent(enUS: "", frFR: "")

	func emptyInstructions() -> LocalizedContent {
		return LocalizedContent(
			enUS: MDInstructions_EN,
			frFR: MDInstructions_FR)
	}

	var MDInstructions_FR: String = """
		## Activité vide

		Sélectionner un modéle dans l'éditeur.

		"""

	var MDInstructions_EN: String = """
		## Empty activity

		Select a model within the editor.

		"""

	func emptyStep() -> Step {
		return Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: ["dummy_1"], sound: nil)
	}

	func makeEmptyStepArray() -> [[Step]] {
		return [
			[
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: ["dummy_1"], sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: ["dummy_1"], sound: nil),
			]
		]
	}

	func stepInstruction() -> LocalizedContent {
		return LocalizedContent(
			enUS: stepInstruction_EN,
			frFR: stepInstruction_FR)
	}

	var stepInstruction_FR: String = ""
	var stepInstruction_EN: String = ""

}
