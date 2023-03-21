//
//  ConnectionView.swift
//  ColorQuest
//
//  Created by Hugo Pezziardi on 17/03/2023.
//

import SwiftUI

struct GridView: View {
	@ObservedObject var robotManager: RobotManager
	let columns = [
		GridItem(.adaptive(minimum: 150))
	]

	var body: some View {
		NavigationView {
			LazyVGrid(columns: columns, alignment: .center) {
				ForEach(Array(robotManager.robots.values), id: \.self) { robot in
					NavigationLink {
						ActivityView(robot: robot)
					} label: {
						VStack {
							Image("robot_connexion_bluetooth")
							Text(robot.name)
						}
					}
					.simultaneousGesture(TapGesture().onEnded{
						robotManager.connect(to: robot)
					})
				}
			}
			.padding(10)
			.navigationTitle("Connection to a Robot")
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}

}

struct ConnectionView: View {
	@ObservedObject var robotManager: RobotManager

	var body: some View {
		GridView(robotManager: robotManager)
	}
}

struct ConnectionView_Previews: PreviewProvider {
	@StateObject static var robotManager = RobotManager()

	static var previews: some View {
		ConnectionView(robotManager: robotManager)
	}
}
