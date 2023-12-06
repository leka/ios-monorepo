// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit
import RobotKit

class RobotInformationViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    @Published var robotSerialNumber = "n/a"
    @Published var robotBattery = "n/a"
    @Published var robotOsVersion = "n/a"
    @Published var robotIsCharging = "n/a"

    init() {
        subscribeToRobotSerialNumberUpdates()
        subscribeToRobotBatteryUpdates()
        subscribeToRobotOsVersionUpdates()
        subscribeToRobotChargingStatusUpdates()
    }

    private func subscribeToRobotSerialNumberUpdates() {
        Robot.shared.serialNumber
            .receive(on: DispatchQueue.main)
            .sink { robotSerialNumber in
                self.robotSerialNumber = robotSerialNumber
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotBatteryUpdates() {
        Robot.shared.battery
            .receive(on: DispatchQueue.main)
            .sink { robotBattery in
                self.robotBattery = "\(robotBattery)%"
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotOsVersionUpdates() {
        Robot.shared.osVersion
            .receive(on: DispatchQueue.main)
            .sink { robotOsVersion in
                self.robotOsVersion = robotOsVersion?.description ?? "(n/a)"
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotChargingStatusUpdates() {
        Robot.shared.isCharging
            .receive(on: DispatchQueue.main)
            .sink { isCharging in
                self.robotIsCharging =
                    isCharging ? String(l10n.general.yes.characters) : String(l10n.general.no.characters)
            }
            .store(in: &cancellables)
    }
}
