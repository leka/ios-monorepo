//
//  BLEKitExampleApp.swift
//  BLEKitExample
//
//  Created by Hugo Pezziardi on 3/27/23.
//

import BLEKit
import CombineCoreBluetooth
import SwiftUI

@main
struct BLEKitExampleApp: App {
	@StateObject var bleManager: BLEManager = BLEManager(centralManager: CentralManager.live())
	@StateObject var robot: Robot = Robot()
	@StateObject var botVM: BotViewModel = BotViewModel()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(bleManager)
				.environmentObject(robot)
				.environmentObject(botVM)
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
				RobotListView()
					.navigationTitle("BLEKitExampleApp")
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())

	}
}
