// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit
import SwiftUI

class RequirementsViewModel: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []

    let requirementsInstructionsText = l10n.update.requirements.instructionsText

    let chargingBasePluggedImage = LekaUpdaterAsset.Assets.chargingBasePlugged.swiftUIImage
    let chargingBasePluggedText = l10n.update.requirements.chargingBasePluggedText

    let chargingBaseGreenLEDImage = LekaUpdaterAsset.Assets.chargingBaseGreenLED.swiftUIImage
    let chargingBaseGreenLEDText = l10n.update.requirements.chargingBaseGreenLEDText

    let robotBatteryMinimumLevelImage = LekaUpdaterAsset.Assets.robotBatteryQuarter1.swiftUIImage
    let robotBatteryMinimumLevelText = l10n.update.requirements.robotBatteryMinimumLevelText

    @Published var robotIsReadyToUpdate = false
    @Published var robotIsNotReadyToUpdate = true

    init() {
        subscribeToRobotBatteryUpdates()
        subscribeToRobotIsChargingUpdates()
    }

    private func subscribeToRobotBatteryUpdates() {
        globalRobotManager.$battery
            .receive(on: DispatchQueue.main)
            .sink { robotBattery in
                self.updateRobotIsReadyToUpdate(
                    robotBattery: robotBattery, robotIsCharging: globalRobotManager.isCharging)
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotIsChargingUpdates() {
        globalRobotManager.$isCharging
            .receive(on: DispatchQueue.main)
            .sink { robotIsCharging in
                self.updateRobotIsReadyToUpdate(
                    robotBattery: globalRobotManager.battery, robotIsCharging: robotIsCharging)
            }
            .store(in: &cancellables)
    }

    private func updateRobotIsReadyToUpdate(robotBattery: Int?, robotIsCharging: Bool?) {
        if let battery = robotBattery, let isCharging = robotIsCharging {
            robotIsReadyToUpdate = battery >= 30 && isCharging
            robotIsNotReadyToUpdate = !robotIsReadyToUpdate
        }
    }

}
