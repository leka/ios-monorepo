//
//  ContentView.swift
//  CentralDemo
//
//  Created by Kevin Lundberg on 3/27/22.
//

import CombineCoreBluetooth
import SwiftUI

struct CentralView: View {
	@StateObject var central: Central = .init()

	var body: some View {
		if let device = central.connectedPeripheral {
			RobotView(robot: Robot(central: central, blePeripheral: device))
		} else {
			Form {
				Section {
					if !central.scanning {
						Button("Search for peripheral") {
							central.searchForPeripherals()
						}
					} else {
						Button("Stop searching") {
							central.stopSearching()
						}
					}

					if let error = central.connectError {
						Text("Error: \(String(describing: error))")
					}
				}

				Section("Discovered peripherals") {
					ForEach(central.peripherals) { discovery in
						Button {
							central.connect(discovery)
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
}
