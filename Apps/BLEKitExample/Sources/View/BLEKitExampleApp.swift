//
//  BLEKitExampleApp.swift
//  BLEKitExample
//
//  Created by Hugo Pezziardi on 3/27/23.
//

import CombineCoreBluetooth
import SwiftUI

@main
struct BLEKitExampleApp: App {
	@StateObject var bleManager: BLEManager = BLEManager(centralManager: CentralManager.live())
	@StateObject var robot = Robot()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(bleManager)
				.environmentObject(robot)
		}
	}
}

struct ContentView: View {
	@EnvironmentObject var bleManager: BLEManager
	@EnvironmentObject var robot: Robot

	var body: some View {
		NavigationView {
			if bleManager.connectedPeripheral != nil {
				RobotView()
					.navigationTitle("BLEKitExampleApp")
			} else {
				ConnexionView()
					.navigationTitle("BLEKitExampleApp")
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())

	}
}
