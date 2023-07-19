// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class RequirementsViewModel: ObservableObject {
    @ObservedObject private var robot: RobotPeripheralViewModel

    let requirementsImage = Image(uiImage: LekaUpdaterAsset.Assets.robotIsCharging.image)

    let requirementsInstructionText = "Pour lancer la mise à jour, veillez à ce que :"

    let chargingBasePluggedImage = LekaUpdaterAsset.Assets.chargingBasePlugged.swiftUIImage
    let chargingBasePluggedText = "Le robot soit posé sur son socle et que le socle soit branché au secteur"

    let chargingBaseGreenLEDImage = LekaUpdaterAsset.Assets.chargingBaseGreenLED.swiftUIImage
    let chargingBaseGreenLEDText = "La LED de charge soit verte indiquant le bon positionnement sur le socle"

    var robotIsReadyToUpdate: Bool {
        robot.battery >= 30 && robot.isCharging
    }

    var robotIsNotReadyToUpdate: Bool {
        !robotIsReadyToUpdate
    }

    init(robot: RobotPeripheralViewModel) {
        self._robot = ObservedObject(wrappedValue: robot)
    }
}
