//
//  LekaCombineCBApp.swift
//  LekaCombineCB
//
//  Created by Hugo Pezziardi on 3/27/23.
//

import SwiftUI

@main
struct LekaCombineCBApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}

struct ContentView: View {
	var body: some View {
		NavigationView {
			ConnexionView()
				.navigationTitle("LekaCombineCBApp")
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}
