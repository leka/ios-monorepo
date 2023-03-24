//
//  BotViewModel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 9/2/23.
//

import SwiftUI

class BotViewModel: ObservableObject {
    
	// Bot Connect
	// Make 'botIsConnected' & 'currentlyConnectedBotIndex' one prop' instead
	// if currentlyConnectedBotIndex != nil, bot is connected for sure
    @Published var currentlySelectedBotIndex: Int? = nil
    @Published var currentlyConnectedBotIndex: Int? = nil
    
	// Bot Advertised Information
    @Published var botIsConnected: Bool = false
    @Published var botChargeLevel: Double = 100
    @Published var botIsCharging: Bool = false
    @Published var currentlyConnectedBotName: String = ""
    @Published var botOSVersion: String = "LekaOS v1.4.0"
	
	func disconnect() {
		currentlySelectedBotIndex = nil
		currentlyConnectedBotIndex = nil
		botIsConnected = false
	}
    
}
