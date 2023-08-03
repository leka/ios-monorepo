// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import SwiftUI

class RequirementsViewModel: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []

    let requirementsInstructionText = "Pour lancer la mise à jour, veillez à ce que :"

    let chargingBasePluggedImage = LekaUpdaterAsset.Assets.chargingBasePlugged.swiftUIImage
    let chargingBasePluggedText = "Le robot soit posé sur son socle et que le socle soit branché au secteur"

    let chargingBaseGreenLEDImage = LekaUpdaterAsset.Assets.chargingBaseGreenLED.swiftUIImage
    let chargingBaseGreenLEDText = "La LED de charge soit verte indiquant le bon positionnement sur le socle"

    let robotBatteryQuarter1Image = LekaUpdaterAsset.Assets.robotBatteryQuarter1.swiftUIImage
    let robotBatteryQuarter1Text = "Votre robot soit chargé à 30% ou plus"

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
