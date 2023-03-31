//
//  PeripheralDemoApp.swift
//  PeripheralDemo
//
//  Created by Kevin Lundberg on 3/25/22.
//

import SwiftUI

@main
struct PeripheralDemoApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}

struct ContentView: View {
	var body: some View {
		NavigationView {
			CentralView()
				.navigationTitle("Central")
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}
