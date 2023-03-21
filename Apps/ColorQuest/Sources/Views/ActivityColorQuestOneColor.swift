//
//  ActivityColorQuest.swift
//  ColorQuest
//
//  Created by Yann LOCATELLI on 22/02/2023.
//

import SwiftUI

struct StepColorQuestOneColor: View {
	let step: Step
	let buttonDiameter = 500.0

	@Binding var isCorrectAnswer: Bool
	@ObservedObject var robot: Robot

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
					colorWasTapped(step.elements[0])
				} label: {
					Circle()
						.foregroundColor(colorDictionary[step.elements[0]]?.app ?? Color.black)
				}
				.frame(width: buttonDiameter, height: buttonDiameter)
				.padding(30)
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

struct ActivityColorQuestOneColor: View {
	let activity: Activity
	@ObservedObject var robot: Robot

	@State private var selectedStep = 0
	@State private var previousStep = 0

    @State private var questionNumber = 1

	@State private var scoreTitle = ""
    @State private var isFinished = false
	@State private var isAnswered = true

    var body: some View {

		StepColorQuestOneColor(step: activity.steps[selectedStep], isCorrectAnswer: $isAnswered, robot: robot)
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

		let robotColor = activity.steps[selectedStep].correctAnswer
		guard let color = colorDictionary[robotColor]?.robot else {return}

		robot.displayFullBelt(red: color[0], green: color[1], blue: color[2])

		isAnswered = false
    }

    func reset() {
        questionNumber = 1
        isFinished = false
        askQuestion()
    }
}

struct ActivityColorQuestOneColor_Previews: PreviewProvider {
	static let activity = ActivitiesVM().getActivity("0e32fbf9-ac5f-4e47-b4c6-e2c50df80f8a-LV-color-quest-1")
	static let robot = Robot(blePeripheral: BLEPeripheral(peripheral: nil))

    static var previews: some View {
		ActivityColorQuestOneColor(activity: activity, robot: robot)
    }
}
