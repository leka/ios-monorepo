//
//  File.swift
//
//
//  Created by Mathieu Jeannot on 29/3/23.
//

import Foundation

// Use this activity for Quick Testing
// Create a baseActivity for the app when it launches (or when resetActivity())
class DemoActivity: ObservableObject {

	func makeBufferActivity() -> Activity {
		return Activity(
			id: UUID(),
			title: defaultTitle,
			short: defaultShort,
			instructions: defaultInstructions(),
			activityType: "touch_to_select",
			stepsAmount: 10,
			isRandom: true,
			numberOfImages: 1,
			randomAnswerPositions: true,
			stepSequence: makeDefaultSteps())
	}

	// MARK: - Default Values
	var defaultTitle = LocalizedContent(
		enUS: "Test Sample",
		frFR: "Échantillon de Test"
	)

	var defaultShort = LocalizedContent(
		enUS: "Test Sample - short",
		frFR: "Échantillon de Test - short"
	)

	func defaultInstructions() -> LocalizedContent {
		return LocalizedContent(
			enUS: MDInstructions_EN,
			frFR: MDInstructions_FR)
	}

	func makeDefaultSteps() -> [[Step]] {
		return [
			[
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers6, sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers3, sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers4, sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers2, sound: nil),
				Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
			]
			//			[Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
			//			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
			//			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
			//			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
			//			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil)
			//			]
		]
	}

	var stepAnswers1 = ["dummy_1"]
	var stepAnswers2 = ["dummy_1", "dummy_2"]
	var stepAnswers3 = ["dummy_1", "dummy_2", "dummy_3"]
	var stepAnswers4 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4"]
	var stepAnswers5 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5"]
	var stepAnswers6 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6"]

	func stepInstruction() -> LocalizedContent {
		return LocalizedContent(
			enUS: stepInstruction_EN,
			frFR: stepInstruction_FR)
	}

	var stepInstruction_FR: String = "Touche le numéro 1"
	var stepInstruction_EN: String = "Touch the number 1"

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

}
