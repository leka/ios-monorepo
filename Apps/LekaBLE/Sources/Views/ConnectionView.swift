//
//  ConnectionView.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 15/03/2023.
//

import SwiftUI

struct ConnectionView: View {
	@ObservedObject var robotManager: RobotManager

	let columns = [
		GridItem(.adaptive(minimum: 200))
	]

	var body: some View {
		NavigationView {
			LazyVGrid(columns: columns) {
				ForEach(Array(robotManager.robots.values)) { robot in
					NavigationLink {
						InformationView(robot: robot)
					} label: {
						VStack {
							Image("robot_connexion_bluetooth")
								.resizable()
								.scaledToFit()
								.frame(width: 100, height: 100)
								.padding()

							Text(robot.osVersion.isEmpty ? "\(robot.name)" : "\(robot.name) (v\(robot.osVersion))")

							Text("\(robot.battery)%")
								.foregroundColor(robot.isCharging ? Color.green : Color.red)
						}
					}
					.simultaneousGesture(
						TapGesture()
							.onEnded {
								robotManager.connect(to: robot)
							})  // TODO: Might fail if too long gesture
				}
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct ConnectionView_Previews: PreviewProvider {
	@StateObject static var robotManager = RobotManager()
	static var previews: some View {
		ConnectionView(robotManager: robotManager)
	}
}
