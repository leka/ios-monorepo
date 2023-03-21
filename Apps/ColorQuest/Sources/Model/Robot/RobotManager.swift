//
//  RobotManager.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 17/02/2023.
//
import Foundation

class RobotManager: ObservableObject {
	private var bleManager: BLEManager

	@Published var robots = [BLEPeripheral: Robot]()

	@Published var updateIndicator = true  // TODO: To remove, used due to robots not updated in View
	init() {
		self.bleManager = BLEManager(advertisingServicesFilter: [BLESpecs.AdvertisingData.service])
		self.bleManager.onPeripheralDetected = self.onRobotDetected
	}

	func onRobotDetected(peripheral: BLEPeripheral) {
		if robots[peripheral] == nil {
			robots[peripheral] = Robot(blePeripheral: peripheral)
		}

		updateIndicator.toggle()
	}

	func connect(to robot: Robot) {
		bleManager.connect(to: robot.blePeripheral)
	}

	func disconnect(from robot: Robot) {
		bleManager.disconnect(from: robot.blePeripheral)
	}
}
