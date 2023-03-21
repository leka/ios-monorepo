//
//  InformationView.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 20/02/2023.
//

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

// TODO: Implement ReadWriteBoolean (e.g. SetFileExchangeState, ClearFile)
// TODO: Implement ReadWriteMultiple (e.g. Robot Name)

struct InformationView: View {
	@ObservedObject var robot: Robot

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
				//                WriteOnlyEventView(characteristicName: "Reboot")
			}
			Group {
				ReadOnlyView(characteristicName: "Magic Card (ID)", characteristicValue: "\(robot.magicCardId)")
				ReadOnlyView(characteristicName: "MagicCard (Language)", characteristicValue: robot.magicCardLanguage)
			}
			//            Group {
			//                WriteOnlyBooleanView(characteristicName: "Set File Exchange State", value: robot.fileExchangeState)
			//                WriteOnlyMultipleView(characteristicName: "Set Path", value: "/fs/...")
			//                WriteOnlyEventView(characteristicName: "Clear file")
			//                ReadOnlyView(characteristicName: "SHA256", characteristicValue: robot.sha256)
			//            }
			//            Group {
			//                WriteOnlyEventView(characteristicName: "Request update")
			//                WriteOnlyEventView(characteristicName: "Request factory reset")
			//                WriteOnlyMultipleView(characteristicName: "Major update", value: "1")
			//                WriteOnlyMultipleView(characteristicName: "Minor update", value: "2")
			//                WriteOnlyMultipleView(characteristicName: "Revision update", value: "3")
			//            }
			Group {
				//                WriteOnlyMultipleView(characteristicName: "Commands", value: "2A2B2C2D")
				HStack {
					Button {
						robot.runReinforcer(robot.commands.LKC.Motivator.blinkGreen)
					} label: {
						Image("reinforcer-1-green-spin")
					}
					Button {
						robot.runReinforcer(robot.commands.LKC.Motivator.spinBlink)
					} label: {
						Image("reinforcer-2-violet_green_blink-spin")
					}
					Button {
						robot.runReinforcer(robot.commands.LKC.Motivator.fire)
					} label: {
						Image("reinforcer-3-fire-static")
					}
					Button {
						robot.runReinforcer(robot.commands.LKC.Motivator.sprinkles)
					} label: {
						Image("reinforcer-4-glitters-static")
					}
					Button {
						robot.runReinforcer(robot.commands.LKC.Motivator.rainbow)
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
}

struct InformationView_Previews: PreviewProvider {
	@StateObject static var robot = Robot(blePeripheral: BLEPeripheral(peripheral: nil))
	static var previews: some View {
		InformationView(robot: robot)
	}
}
