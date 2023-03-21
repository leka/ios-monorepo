//
//  ContentView.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 17/02/2023.
//

import SwiftUI

struct ContentView: View {
	@StateObject var robotManager = RobotManager()

	var body: some View {
		ConnectionView(robotManager: robotManager)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
