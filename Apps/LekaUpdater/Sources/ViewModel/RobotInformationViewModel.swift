// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class RobotInformationViewModel: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []

    @Published var robotSerialNumber = "n/a"
    @Published var robotBattery = "n/a"
    @Published var robotOsVersion = "n/a"
    @Published var robotIsCharging = false

    init() {
        subscribeToRobotSerialNumberUpdates()
        subscribeToRobotBatteryUpdates()
        subscribeToRobotOsVersionUpdates()
        subscribeToRobotChargingStatusUpdates()
    }

    private func subscribeToRobotSerialNumberUpdates() {
        globalRobotManager.$serialNumber
            .receive(on: DispatchQueue.main)
            .sink { robotSerialNumber in
                self.robotSerialNumber = robotSerialNumber ?? "n/a"
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotBatteryUpdates() {
        globalRobotManager.$battery
            .receive(on: DispatchQueue.main)
            .sink { robotBattery in
                if let robotBattery = robotBattery {
                    self.robotBattery = "\(robotBattery)"
                } else {
                    self.robotBattery = "n/a"
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotOsVersionUpdates() {
        globalRobotManager.$osVersion
            .receive(on: DispatchQueue.main)
            .sink { robotOsVersion in
                self.robotOsVersion = robotOsVersion?.description ?? "n/a"
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotChargingStatusUpdates() {
        globalRobotManager.$isCharging
            .receive(on: DispatchQueue.main)
            .sink {
                self.robotIsCharging = $0 ?? false
            }
            .store(in: &cancellables)
    }

}
