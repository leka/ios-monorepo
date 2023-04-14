// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

class BotViewModel: ObservableObject {

    // Bot Connect
    // Make 'botIsConnected' & 'currentlyConnectedBotIndex' one prop' instead
    // if currentlyConnectedBotIndex is not nil, bot is connected for sure
    @Published var currentlySelectedBotIndex: Int?
    @Published var currentlyConnectedBotIndex: Int?

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
