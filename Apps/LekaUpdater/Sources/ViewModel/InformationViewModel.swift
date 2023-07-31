// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class InformationViewModel: ObservableObject {

    private var firmware: FirmwareManager
    private var cancellables: Set<AnyCancellable> = []

    @Published var robotManager: RobotManager

    @Published var showRobotNeedsUpdate: Bool = true
    @Published var robotName: String

    @Published var firmwareVersion: String

    init(robotManager: RobotManager, firmware: FirmwareManager) {
        self.robotManager = robotManager
        self.firmware = firmware

        self.robotName = robotManager.name ?? "n/a"
        self.firmwareVersion = firmware.currentVersion

        self.subscribeToRobotOsVersionUpdates()
    }

    public func onAppear() {
        robotManager.readReadOnlyCharacteristics()
        robotManager.subscribeToCharacteristicsNotifications()
    }

    public func switchRobotVersionForDebug() {
        if robotManager.osVersion == "1.3.0" {
            robotManager.osVersion = "1.4.0"
        } else {
            robotManager.osVersion = "1.3.0"
        }
    }  // TODO: Remove DEBUG

    private func subscribeToRobotOsVersionUpdates() {
        robotManager.$osVersion
            .receive(on: DispatchQueue.main)
            .sink { robotOsVersion in
                self.updateShowRobotNeedsUpdate(robotOsVersion: robotOsVersion)
            }
            .store(in: &cancellables)
    }

    private func updateShowRobotNeedsUpdate(robotOsVersion: String?) {
        if let robotOsVersion = robotOsVersion {
            showRobotNeedsUpdate = firmware.compareWith(version: robotOsVersion) == .needsUpdate
        } else {
            showRobotNeedsUpdate = false
        }
    }
}
