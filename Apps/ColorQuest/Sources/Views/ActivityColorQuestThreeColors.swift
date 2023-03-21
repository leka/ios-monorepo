//
//  ActivityColorQuestThreeColors.swift
//  ColorQuest
//
//  Created by Yann LOCATELLI on 22/02/2023.
//

import SwiftUI

struct StepColorQuestThreeColors: View {
	let step: Step

	let buttonDiameter = 240.0

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

			HStack(spacing: 160) {
				Button  {
					colorWasTapped(step.elements[array[0]])
				} label: {
					Circle()
						.foregroundColor(colorDictionary[step.elements[array[0]]]?.app ?? Color.black)
				}
				.frame(width: buttonDiameter, height: buttonDiameter)

				Button  {
					colorWasTapped(step.elements[array[1]])
				} label: {
					Circle()
						.foregroundColor(colorDictionary[step.elements[array[1]]]?.app ?? Color.black)
				}
				.frame(width: buttonDiameter, height: buttonDiameter)
			}
			.padding(.top, 40)

			Button  {
				colorWasTapped(step.elements[array[2]])
			} label: {
				Circle()
					.foregroundColor(colorDictionary[step.elements[array[2]]]?.app ?? Color.black)
			}
			.frame(width: buttonDiameter, height: buttonDiameter)
			.padding(30)
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

struct ActivityColorQuestThreeColors: View {
	@State var activity: Activity
	@ObservedObject var robot: Robot

	@State private var selectedStep: Int
	@State private var previousStep = 0

	@State private var questionNumber = 1

	@State private var scoreTitle = ""
	@State private var isFinished = false
	@State private var isAnswered = false

	@State private var array = [0, 1, 2]

	init(activity: Activity, robot: Robot) {
		self.activity = activity
		self.robot = robot
		self.selectedStep = 0
		self.previousStep = previousStep
		self.questionNumber = questionNumber
		self.scoreTitle = scoreTitle
		self.isFinished = isFinished
		self.isAnswered = isAnswered
		self.array = array

		askQuestion()
	}

	var body: some View {
		StepColorQuestThreeColors(step: activity.steps[selectedStep], isCorrectAnswer: $isAnswered, robot: robot, array: array)
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

	func reset() {
		questionNumber = 1
		isFinished = false
		askQuestion()
	}

	func randomizeStep() {
		if let randomPosition = activity.randomElementPosition {
			if randomPosition {
				array.shuffle()
			}
		}
	}
}

 struct ActivityColorQuestThreeColors_Previews: PreviewProvider {
	static let activity = ActivitiesVM().getActivity("7d3c62d0-9544-4215-a2b3-2e21b24aef77-LV-color-quest-3")
	static let robot = Robot(blePeripheral: BLEPeripheral(peripheral: nil))

	static var previews: some View {
		ActivityColorQuestThreeColors(activity: activity, robot: robot)
	}
 }
