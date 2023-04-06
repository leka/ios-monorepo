//
//  ConnexionView.swift
//  BLEKitExample
//
//  Created by Hugo Pezziardi on 3/27/23.
//

import CombineCoreBluetooth
import SwiftUI

struct ConnexionView: View {
	@EnvironmentObject var bleManager: BLEManager
	@EnvironmentObject var robot: Robot

	var body: some View {
		Form {
			Section {
				if !bleManager.isScanning {
					Button("Search for peripheral") {
						bleManager.searchForPeripherals()
					}
				} else {
					Button("Stop searching") {
						bleManager.stopSearching()
					}
				}
			}

			Section("Discovered peripherals") {
				ForEach(bleManager.peripherals) { discovery in
					Button {
						bleManager.connect(discovery)
							.sink(
								receiveCompletion: { _ in },
								receiveValue: { peripheral in
									let connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
									robot.robotPeripheral = connectedRobotPeripheral
								}
							)
							.store(in: &bleManager.cancellables)
					} label: {
						VStack(alignment: .leading) {
							if let advertisementData = AdvertisingData(discovery.advertisementData) {
								Text("Name : \(advertisementData.name)")

								Text("Battery level : \(advertisementData.battery)")

								Text("Charging Status : " + (advertisementData.isCharging ? "On" : "Off"))

								Text("OS Version : \(advertisementData.osVersion)")
							}
						}
					}
				}
			}
		}
	}
}
