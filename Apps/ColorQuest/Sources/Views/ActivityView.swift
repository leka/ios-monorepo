//
//  ActivityView.swift
//  ColorQuest
//
//  Created by Hugo Pezziardi on 17/03/2023.
//

import SwiftUI

struct GoBackButton: View {
	var body: some View {
		Button {
			// nothing to do
		} label: {
			Image(systemName: "chevron.backward")
				.imageScale(.large)
		}
		.font(.headline.bold().weight(.heavy))
		.foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.7))

	}
}

struct ActivityTitle: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.headline.bold().weight(.heavy))
			.foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.7))
	}
}

struct InfoButton: View {
	var body: some View {
		Button {
			// nothing to do
		} label: {
			Image(systemName: "info.circle")
				.imageScale(.large)
		}
		.font(.headline.bold().weight(.heavy))
		.foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.7))

	}
}

struct ActivityDescription: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.title3.bold().weight(.semibold))
			.foregroundColor(.gray)
	}
}

struct ActivityDescriptioned: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(maxWidth: 600)
			.padding(.vertical, 15)
			.background(.regularMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}

struct ReadSpeakerButton: View {
	var body: some View {
		Button {
			// nothing to do
		} label: {
			Image(systemName: "speaker.wave.2")
				.imageScale(.large)
				.foregroundColor(.gray)
				.font(.title.weight(.semibold))
				.padding(10)
		}
	}
}

extension View {
	func activityTitled() -> some View {
		modifier(ActivityTitle())
	}

	func activityDescription() -> some View {
		modifier(ActivityDescription())
	}

	func activityDescriptioned() -> some View {
		modifier(ActivityDescriptioned())
	}
}

struct ActivityView: View {
	@State private var colorsNumber = 0
	@StateObject var robot: Robot

	let yamlFiles = ["0e32fbf9-ac5f-4e47-b4c6-e2c50df80f8a-LV-color-quest-1", "87925cb8-fe9f-403f-8c07-525441328b2f-LV-color-quest-2", "7d3c62d0-9544-4215-a2b3-2e21b24aef77-LV-color-quest-3"]

	var body: some View {
		ZStack {
			Spacer()

			LekaBackground()

			VStack {
				HStack {
					GoBackButton()
					Spacer()
					Text("Loto des couleurs")
						.activityTitled()
					Spacer()
					InfoButton()
				}

				Spacer()

				VStack {
					Picker("Number of color", selection: $colorsNumber) {
						ForEach(0..<3) {
							Text("\($0 + 1) colors")
						}
					}
					.frame(maxWidth: 600)
					.pickerStyle(.segmented)
				}

				Spacer()

				switch colorsNumber{
					case 0:
						ActivityColorQuestOneColor(activity: ActivitiesVM().getActivity(yamlFiles[0]), robot: robot)
					case 1:
						ActivityColorQuestTwoColors(activity: ActivitiesVM().getActivity(yamlFiles[1]), robot: robot)
					case 2:
						ActivityColorQuestThreeColors(activity: ActivitiesVM().getActivity(yamlFiles[2]), robot: robot)
					default:
						ActivityColorQuestOneColor(activity: ActivitiesVM().getActivity(yamlFiles[0]), robot: robot)
				}

				Spacer()
				Spacer()

			}
			.padding()
		}
	}
}

struct ActivityView_Previews: PreviewProvider {
	@StateObject static var robotManager = RobotManager()
	static let robot = Robot(blePeripheral: BLEPeripheral(peripheral: nil))

    static var previews: some View {
		ActivityView(robot: robot)
    }
}
