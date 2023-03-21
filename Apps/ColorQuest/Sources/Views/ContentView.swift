//
//  ContentView.swift
//  ColorQuest
//
//  Created by Hugo Pezziardi on 16/02/2023.
//

import SwiftUI

struct LekaBackground: View {
	var body: some View {
		Color(red: 0.0, green: 0.6, blue: 1.0)
			.opacity(0.3)
			.ignoresSafeArea()
	}
}

struct ContentView: View {
		@StateObject var robotManager = RobotManager()

		var body: some View {
			VStack {
				if robotManager.robots.count != 0 {
					ConnectionView(robotManager: robotManager)
				}			}
		}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
