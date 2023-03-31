//
//  RobotView.swift
//  LekaCombineCB
//
//  Created by Hugo Pezziardi on 29/03/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import CombineCoreBluetooth
import SwiftUI

struct ReadOnlyView: View {
	var characteristicName: String
	var characteristicValue: String

	var body: some View {
		HStack {
			Text("\(characteristicName): ")
				.bold()
			Text(characteristicValue)
		}
	}
}

struct WriteOnlyEventView: View {
	var characteristicName: String

	var body: some View {
		HStack {
			Text("\(characteristicName): ")
				.bold()
			Button("Apply") {
				// TODO: do something related to write on char
			}
		}
	}
}

struct WriteOnlyBooleanView: View {
	var characteristicName: String
	@State var value: Bool

	var body: some View {
		HStack {
			Text("\(characteristicName): ")
				.bold()
			Button(value ? "On" : "Off") {
				value.toggle()
				// TODO: do something related to write on char
			}
		}
	}
}

struct WriteOnlyMultipleView: View {
	var characteristicName: String
	@State var value: String

	var body: some View {
		HStack {
			Text("\(characteristicName): ")
				.bold()
			TextField("Current value", text: $value).frame(maxWidth: 250.0)
			Button("Apply") {
				// TODO: do something related to write on char
			}
		}
	}
}

struct RobotView: View {
	@ObservedObject var robot: Robot

	@State private var name = ""

	var body: some View {
		VStack(alignment: .leading) {

			Group {
				ReadOnlyView(characteristicName: "Manufacturer", characteristicValue: robot.manufacturer)
				ReadOnlyView(characteristicName: "Model Number", characteristicValue: robot.modelNumber)
				ReadOnlyView(characteristicName: "Serial Number", characteristicValue: robot.serialNumber)
				ReadOnlyView(characteristicName: "OS Version", characteristicValue: robot.osVersion)
			}

			Group {
				ReadOnlyView(characteristicName: "Battery", characteristicValue: "\(robot.battery)")
				ReadOnlyView(
					characteristicName: "Charging status", characteristicValue: robot.isCharging ? "On" : "Off")
			}

			Group {
				ReadOnlyView(characteristicName: "Magic Card (ID)", characteristicValue: "\(robot.magicCardId)")
				ReadOnlyView(characteristicName: "MagicCard (Language)", characteristicValue: robot.magicCardLanguage)
			}

			Group {
				HStack {
					Button {
						robot.runReinforcer(robot.commands.command.Motivator.blinkGreen)
					} label: {
						Image("reinforcer-1-green-spin")
					}
					Button {
						robot.runReinforcer(robot.commands.command.Motivator.spinBlink)
					} label: {
						Image("reinforcer-2-violet_green_blink-spin")
					}
					Button {
						robot.runReinforcer(robot.commands.command.Motivator.fire)
					} label: {
						Image("reinforcer-3-fire-static")
					}
					Button {
						robot.runReinforcer(robot.commands.command.Motivator.sprinkles)
					} label: {
						Image("reinforcer-4-glitters-static")
					}
					Button {
						robot.runReinforcer(robot.commands.command.Motivator.rainbow)
					} label: {
						Image("reinforcer-5-rainbow-static")
					}
				}
			}

			Divider()

			Button("Update data") {
				robot.readRequestAll()
			}
		}
		.padding()
	}

	func label<T>(for result: Result<T, Error>?) -> some View {
		Group {
			switch result {
				case let .success(value)?:
					Text("Wrote at \(String(describing: value))")
				case let .failure(error)?:
					if let error = error as? LocalizedError, let errorDescription = error.errorDescription {
						Text("Error: \(errorDescription)")
					} else {
						Text("Error: \(String(describing: error))")
					}
				case nil:
					EmptyView()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		CentralView()
	}
}
