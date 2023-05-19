// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class RequirementsViewModel: ObservableObject {
    @ObservedObject private var robot: DummyRobotModel

    let requirementsImage = Image(uiImage: LekaUpdaterAsset.Assets.robotIsCharging.image)


    var robotIsNotReadyToUpdate: Bool {
        !(robot.battery >= 30 && robot.isCharging)
    }

    init(robot: DummyRobotModel) {
        self._robot = ObservedObject(wrappedValue: robot)
    }
}
