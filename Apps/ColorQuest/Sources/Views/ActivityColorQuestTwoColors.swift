//
//  ActivityColorQuestTwoColors.swift
//  ColorQuest
//
//  Created by Yann LOCATELLI on 22/02/2023.
//

import SwiftUI

struct StepColorQuestTwoColors: View {
	let step: Step
	let buttonDiameter = 400.0

	@Binding var isCorrectAnswer: Bool
	@ObservedObject var robot: Robot

	var array: [Int]

	var body: some View {
		VStack {
			HStack  {
				Text(step.instruction.localized())
					.activityDescription()

				ReadSpeakerButton()
			}
			.activityDescriptioned()

			HStack {
				Button  {
					colorWasTapped(step.elements[array[0]])
				} label: {
					Circle()
						.foregroundColor(colorDictionary[step.elements[array[0]]]?.app ?? Color.black)
				}
				.frame(width: buttonDiameter, height: buttonDiameter)
				.padding(60)

				Button  {
					colorWasTapped(step.elements[array[1]])
				} label: {
					Circle()
						.foregroundColor(colorDictionary[step.elements[array[1]]]?.app ?? Color.black)
				}
				.frame(width: buttonDiameter, height: buttonDiameter)
				.padding(60)
			}
		}

	}

	func colorWasTapped(_ color: String) {
		if color == step.correctAnswer {
			robot.runReinforcer(robot.commands.LKC.Motivator.rainbow)

			sleep(10)

			isCorrectAnswer = true
		}
	}
}

struct ActivityColorQuestTwoColors: View {
	@State var activity: Activity
	@ObservedObject var robot: Robot

	@State private var selectedStep = 0
	@State private var previousStep = 0

	@State private var questionNumber = 1

	@State private var scoreTitle = ""
	@State private var isFinished = false
	@State private var isAnswered = false

	@State private var array = [0, 1]

	var body: some View {
		StepColorQuestTwoColors(step: activity.steps[selectedStep], isCorrectAnswer: $isAnswered, robot: robot, array: array)
			.alert("Bravo !", isPresented: $isFinished) {
				HStack{
					Button("Quitter l'activité", action: reset)
					Button("Rejouer", action: reset)
				}
			} message: {
				Text("Tu as réussi l'activité \(activity.stepsAmount) fois sur \(activity.stepsAmount) (100%)!")
			}
			.onChange(of: isAnswered) { answer in
				if answer {
					askQuestion()
				}
			}
	}

	func askQuestion() {
		if activity.isRandom {
			while previousStep == selectedStep {
				selectedStep = Int.random(in: 0..<activity.steps.count)
			}
			previousStep = selectedStep
		} else {
			selectedStep = (selectedStep + 1) % activity.steps.count
		}

		randomizeStep()

		let robotColor = activity.steps[selectedStep].correctAnswer
		guard let color = colorDictionary[robotColor]?.robot else {return}

		robot.displayFullBelt(red: color[0], green: color[1], blue: color[2])
	}

	func randomizeStep() {
		if let randomPosition = activity.randomElementPosition {
			if randomPosition {
				array.shuffle()
			}
		}
	}

	func reset() {
		questionNumber = 1
		isFinished = false
		askQuestion()
	}
}

 struct ActivityColorQuestTwoColors_Previews: PreviewProvider {
	static let activity = ActivitiesVM().getActivity("87925cb8-fe9f-403f-8c07-525441328b2f-LV-color-quest-2")
	static let robot = Robot(blePeripheral: BLEPeripheral(peripheral: nil))

	static var previews: some View {
		ActivityColorQuestTwoColors(activity: activity, robot: robot)
	}
 }
