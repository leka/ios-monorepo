// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit
import RobotKit

@Observable
class RobotInformationViewModel {
    // MARK: Lifecycle

    init() {
        self.subscribeToRobotSerialNumberUpdates()
        self.subscribeToRobotBatteryUpdates()
        self.subscribeToRobotOsVersionUpdates()
        self.subscribeToRobotChargingStatusUpdates()
    }

    // MARK: Internal

    var robotSerialNumber = "n/a"
    var robotBattery = "n/a"
    var robotOsVersion = "n/a"
    var robotIsCharging = "n/a"

    // MARK: Private

    @ObservationIgnored
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
