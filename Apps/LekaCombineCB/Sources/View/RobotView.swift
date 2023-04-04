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

struct RobotView: View {
	@StateObject var robot: Robot

	@State private var backToConnexionMenu = false

	var body: some View {
		if backToConnexionMenu {
			ConnexionView()
		} else {
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
					ReadOnlyView(
						characteristicName: "MagicCard (Language)", characteristicValue: robot.magicCardLanguage)
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
			}
			.padding()
			.toolbar {
				Button {
					guard let connectedPeripheral = robot.central.connectedPeripheral else { return }

					robot.central.disconnect(connectedPeripheral)
					backToConnexionMenu = true
				} label: {
					Text("Connect to another robot")
				}
			}
		}
	}
}
