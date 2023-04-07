//
//  OneGroup.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import Foundation

class ExplorerActivity: ObservableObject {

	var withTemplate: Int

	init(withTemplate: Int) {
		self.withTemplate = withTemplate
	}

	func makeActivity() -> Activity {
		return Activity(
			id: UUID(),
			title: emptyTitle,
			short: emptyShort,
			instructions: emptyInstructions(),
			activityType: "touch_to_select",
			stepsAmount: 10,
			isRandom: false,
			numberOfImages: 1,
			randomAnswerPositions: false,
			stepSequence: makeEmptyStepArray())
	}

	// MARK: - Empty Activity Values
	var emptyTitle = LocalizedContent(
		enUS: "Templates testing in english",
		frFR: "Test des templates en français"
	)

	var emptyShort = LocalizedContent(
		enUS: "Subject - 1",
		frFR: "Sujet - 1"
	)

	func emptyInstructions() -> LocalizedContent {
		return LocalizedContent(
			enUS: MDInstructions_EN,
			frFR: MDInstructions_FR)
	}

	var MDInstructions_FR: String = """
		## Objectif

		L’enfant doit toucher la photo demandée.

		## Matériel

		Pas de matériel particulier nécessaire pour cette activité.


		## Préparation de la séance

		Pas de préparation particulière nécessaire pour cette activité.


		## Déroulé

		1. Sur l'écran touchez le haut-parleur pour que l'enfant puisse entendre la consigne
		1. Incitez verbalement l'enfant à toucher la photo demandée
		1. Répétez si nécessaire la consigne
		1. Quand l'enfant a réussi, Leka lance alors un renforçateur
		1. **Renforcez socialement l'enfant** en même temps


		## Séquence

		Répétez le déroulé **10 fois**.


		## Validation de la leçon

		La leçon est validée lorsque **8 images sur 10** ont été bien sélectionnées.

		"""

	var MDInstructions_EN: String = """
		## Goal

		The child must touch the requested photo.


		## Equipment

		No special equipment needed for this activity.


		## Preparation of the session

		No special preparation necessary for this activity.


		## Steps

		1. On the screen, touch the speaker button to make the child hear the instruction
		1. Verbally encourage the child to click on the requested photo
		1. If necessary repeat the instruction
		1. When the child touches the right photo then Leka launches a reinforcer
		1. **Give the child a social reinforcement** at the same time


		## Sequence

		Repeat the steps **10 times**.


		## How to validate the lesson

		The lesson is validated when **8 images out of 10** have been correctly selected.

		"""

	func makeEmptyStepArray() -> [[Step]] {
		return [
			[
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
			]
		]
	}

	private func setAnswers() -> [String] {
		if withTemplate == 0 {
			return stepAnswers1
		} else if withTemplate == 1 {
			return stepAnswers2
		} else if 2...3 ~= withTemplate {
			return stepAnswers3
		} else if 4...6 ~= withTemplate {
			return stepAnswers4
		} else {
			return stepAnswers6
		}
	}

	var stepAnswers1 = ["dummy_1"]
	var stepAnswers2 = ["dummy_1", "dummy_2"]
	var stepAnswers3 = ["dummy_1", "dummy_2", "dummy_3"]
	var stepAnswers4 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4"]
	var stepAnswers6 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6"]

	func stepInstruction() -> LocalizedContent {
		return LocalizedContent(
			enUS: stepInstruction_EN,
			frFR: stepInstruction_FR)
	}

	var stepInstruction_FR: String = "Touche le numéro 1"
	var stepInstruction_EN: String = "Touch the number 1"
}
