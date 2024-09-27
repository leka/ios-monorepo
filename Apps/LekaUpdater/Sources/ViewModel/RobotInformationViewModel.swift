// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit
import RobotKit

class RobotInformationViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        self.subscribeToRobotSerialNumberUpdates()
        self.subscribeToRobotBatteryUpdates()
        self.subscribeToRobotOsVersionUpdates()
        self.subscribeToRobotChargingStatusUpdates()
    }

    // MARK: Internal

    @Published var robotSerialNumber = "n/a"
    @Published var robotBattery = "n/a"
    @Published var robotOsVersion = "n/a"
    @Published var robotIsCharging = "n/a"

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToRobotSerialNumberUpdates() {
        Robot.shared.serialNumber
            .receive(on: DispatchQueue.main)
            .sink { robotSerialNumber in
                self.robotSerialNumber = robotSerialNumber
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToRobotBatteryUpdates() {
        Robot.shared.battery
            .receive(on: DispatchQueue.main)
            .sink { robotBattery in
                self.robotBattery = "\(robotBattery)%"
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToRobotOsVersionUpdates() {
        Robot.shared.osVersion
            .receive(on: DispatchQueue.main)
            .sink {
                if let version = $0 {
                    self.robotOsVersion = "\(version.major).\(version.minor)"
                } else {
                    self.robotOsVersion = "(n/a)"
                }
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToRobotChargingStatusUpdates() {
        Robot.shared.isCharging
            .receive(on: DispatchQueue.main)
            .sink { isCharging in
                self.robotIsCharging =
                    isCharging ? String(l10n.general.yes.characters) : String(l10n.general.no.characters)
            }
            .store(in: &self.cancellables)
    }
}
