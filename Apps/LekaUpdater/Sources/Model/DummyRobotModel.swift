// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class DummyRobotModel: ObservableObject {
    @Published var name = "Leka"
    @Published var serialNumber = "LK-2206.."

    @Published var battery = 75
    @Published var isCharging = true
    @Published var osVersion = "1.3.0"

    public var event = PassthroughSubject<UpdateProcessEvent, Error>()

    var debugTimer: Timer?

    func startUpdate() {
        // Start update process here
        print("Start Update")
    }

    init() {
        self.debugTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: onTick)
    }

    func onTick(timer: Timer) {
        battery = battery < 100 ? battery + 1 : 0
        if battery % 10 == 0 {
            isCharging.toggle()
        }
    }
}
