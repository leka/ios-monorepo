// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class InformationViewModel: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []

    @Published var robotConnectedChange: Bool = false

    @Published var showRobotNeedsUpdate: Bool = true
    @Published var robotName: String = "n/a"

    @Published var firmwareVersion = globalFirmwareManager.currentVersion

    init() {
        self.subscribeToRobotPeripheral()

        self.subscribeToRobotNameUpdates()
        self.subscribeToRobotOsVersionUpdates()
    }

    public func onViewReappear() {
        self.robotName = globalRobotManager.name ?? "n/a"

        globalRobotManager.readReadOnlyCharacteristics()
        globalRobotManager.subscribeToCharacteristicsNotifications()
    }

    public func switchRobotVersionForDebug() {
        if globalRobotManager.osVersion == "1.3.0" {
            globalRobotManager.osVersion = "1.4.0"
        } else {
            globalRobotManager.osVersion = "1.3.0"
        }
    }  // TODO: Remove DEBUG

    private func subscribeToRobotPeripheral() {
        globalRobotManager.$robotPeripheral
            .receive(on: DispatchQueue.main)
            .sink { robot in
                if robot != nil {
                    self.robotConnectedChange.toggle()
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotNameUpdates() {
        globalRobotManager.$name
            .receive(on: DispatchQueue.main)
            .sink { robotName in
                self.robotName = robotName ?? "n/a"
            }
            .store(in: &cancellables)
    }

    private func subscribeToRobotOsVersionUpdates() {
        globalRobotManager.$osVersion
            .receive(on: DispatchQueue.main)
            .sink { robotOsVersion in
                self.updateShowRobotNeedsUpdate(robotOsVersion: robotOsVersion)
            }
            .store(in: &cancellables)
    }

    private func updateShowRobotNeedsUpdate(robotOsVersion: String?) {
        if let robotOsVersion = robotOsVersion {
            showRobotNeedsUpdate = globalFirmwareManager.compareWith(version: robotOsVersion) == .needsUpdate
        } else {
            showRobotNeedsUpdate = false
        }
    }
}
