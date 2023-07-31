// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class RequirementsViewModel: ObservableObject {
    @ObservedObject private var robotManager: RobotManager

    let requirementsInstructionText = "Pour lancer la mise à jour, veillez à ce que :"

    let chargingBasePluggedImage = LekaUpdaterAsset.Assets.chargingBasePlugged.swiftUIImage
    let chargingBasePluggedText = "Le robot soit posé sur son socle et que le socle soit branché au secteur"

    let chargingBaseGreenLEDImage = LekaUpdaterAsset.Assets.chargingBaseGreenLED.swiftUIImage
    let chargingBaseGreenLEDText = "La LED de charge soit verte indiquant le bon positionnement sur le socle"

    let robotBatteryQuarter1Image = LekaUpdaterAsset.Assets.robotBatteryQuarter1.swiftUIImage
    let robotBatteryQuarter1Text = "Votre robot soit chargé à 30% ou plus"

    var robotIsReadyToUpdate: Bool {
        if let battery = robotManager.battery, let isCharging = robotManager.isCharging {
            return battery >= 30 && isCharging
        }

        return false
    }

    var robotIsNotReadyToUpdate: Bool {
        !robotIsReadyToUpdate
    }

    init(robotManager: RobotManager) {
        self._robotManager = ObservedObject(wrappedValue: robotManager)
    }
}
