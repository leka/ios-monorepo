//
//  ConnexionView.swift
//  LekaCombineCB
//
//  Created by Hugo Pezziardi on 3/27/23.
//

import CombineCoreBluetooth
import SwiftUI

struct ConnexionView: View {
	@StateObject var central: Central = .init()

	var body: some View {
		if let device = central.connectedPeripheral {
			RobotView(central: central, peripheral: device)
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
