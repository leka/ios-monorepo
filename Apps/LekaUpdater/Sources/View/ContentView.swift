//
//  ContentView.swift
//  ios-leka_update
//
//  Created by Yann LOCATELLI on 20/09/2022.
//

import SwiftUI

struct ContentView: View {
	let osVersion: String = Bundle.main.object(forInfoDictionaryKey: "os_version") as! String

	@StateObject var robotManager = RobotManager()

	@State private var selectedRobotIndex = 0

	var body: some View {
		VStack {
			Image("leka-logo")
				.resizable()
				.aspectRatio(CGSize(width: 1000, height: 715), contentMode: .fit)
				.frame(maxHeight: 100)

			VStack {
				VStack {
					HStack {
						Text("Robot")
						Picker("Robot", selection: $selectedRobotIndex, content: {
							ForEach(0..<robotManager.robots.count, id: \.self, content: { robotIndex in
								Text(robotManager.robots[robotIndex].name).tag(robotIndex)
							})
						}).disabled(robotManager.connectedRobot != nil)
						.frame(width: 250)
						Button(robotManager.connectedRobot == nil ? "Connection" : "Disconnection") {
							if robotManager.connectedRobot != nil {
								robotManager.disconnect()
							} else if !robotManager.robots.isEmpty {
								robotManager.connect(to: robotManager.robots[selectedRobotIndex])
							}
						}
						.disabled(robotManager.robots.isEmpty)
						Text("Connected ✔")
							.foregroundColor(Color.gray)
							.opacity(robotManager.connectedRobot == nil ? 0 : 1)
					}
				}.padding()// (ConnectionView)

				VStack {
					List {
						Text(robotManager.connectedRobot == nil ?
								robotManager.robots.isEmpty ? "Name: -" : "Name: (\(robotManager.robots[selectedRobotIndex].name))" :
								"Name: \(robotManager.connectedRobot!.name)")
						Text(robotManager.connectedRobot == nil ?
								robotManager.robots.isEmpty ? "Battery: -" : "Battery: (\(robotManager.robots[selectedRobotIndex].battery))" :
								"Battery: \(robotManager.connectedRobot!.battery)")
						Text(robotManager.connectedRobot == nil ?
								robotManager.robots.isEmpty ? "In charge: -" : robotManager.robots[selectedRobotIndex].isCharging ? "In charge: (yes)" : "In charge: (no)" :
								robotManager.connectedRobot!.isCharging ? "In charge: yes" : "In charge: no")
						Text(robotManager.connectedRobot == nil ?
								robotManager.robots.isEmpty || robotManager.robots[selectedRobotIndex].osVersion == nil ? "Version: -" : "Version: (\(robotManager.robots[selectedRobotIndex].osVersion!))" :
								robotManager.connectedRobot!.osVersion == nil ? "Version: -" :
								"Version: \(robotManager.connectedRobot!.osVersion!)")
					}
				}.padding() // (RobotInformationView)

				VStack {
					HStack {
						Button("Start update process (v\(osVersion))") {
							robotManager.applyUpdate()
						}
						.disabled(robotManager.connectedRobot == nil ||
									robotManager.connectedRobot!.osVersion == nil ||
									robotManager.connectedRobot!.osVersion!.compare(osVersion, options: .numeric) != .orderedAscending ||
									robotManager.sendingFileProgression > 0
						)
						.alert(isPresented: Binding<Bool>(
							get: {() -> Bool in
								robotManager.isSendingFileAndNotCharging || robotManager.applyingUpdateFail
							},
							set: {(_) -> Void in
								robotManager.isSendingFileAndNotCharging = false
								robotManager.applyingUpdateFail = false
							}
						)) {
							if robotManager.isSendingFileAndNotCharging {
								return Alert(title: Text("⚠️ WARNING ⚠️\nRobot not in charge."))
							} else {
								return Alert(title: Text("Oops!... 🙁\nSomething's wrong..."),
											 message: Text("The update process failed, please try again"))
							}
						}
						ProgressView(value: robotManager.sendingFileProgression)
							.opacity(robotManager.sendingFileProgression > 0 ? 1 : 0)
						Text(robotManager.sendingFileIsPaused ? "Update paused,\nwill resume shortly" : "Rebooting...")
							.foregroundColor(Color.gray)
							.multilineTextAlignment(.center)
							.opacity(robotManager.sendingFileProgression >= 1 || robotManager.sendingFileIsPaused ? 1 : 0 )
					}
					Text("To start the update process, the robot must be charging and have at least 30% of battery.")
						.foregroundColor(Color.gray)
						.font(.footnote)
					Text("⚠️ Please keep the \"Emergency Stop 🛑\" magic card nearby during update process, to reboot the robot in case of failure ⚠️")
						.foregroundColor(Color.red)
						.font(.footnote)
					Text(robotManager.errorMessage)
						.foregroundColor(Color.red)
				}.padding() // (UpdateView)

			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
