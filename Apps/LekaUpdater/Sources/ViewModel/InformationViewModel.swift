// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class InformationViewModel: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []

    @Published var showRobotCannotBeUpdated: Bool = false
    @Published var showRobotNeedsUpdate: Bool = true
    @Published var robotName: String = "n/a"
    @Published var robotOSVersion: String = ""

    init() {
        self.subscribeToRobotNameUpdates()
        self.subscribeToRobotOsVersionUpdates()
    }

    public func onViewReappear() {
        self.robotName = globalRobotManager.name ?? "n/a"

        globalRobotManager.readReadOnlyCharacteristics()
        globalRobotManager.subscribeToCharacteristicsNotifications()
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
                self.updateShowRobotCannotBeUpdated(robotOsVersion: robotOsVersion)
                self.updateShowRobotNeedsUpdate(robotOsVersion: robotOsVersion)
                self.robotOSVersion = robotOsVersion ?? ""
            }
            .store(in: &cancellables)
    }

    private func updateShowRobotCannotBeUpdated(robotOsVersion: String?) {
        guard let robotOsVersion = robotOsVersion else { return }

        let isUpdateProcessAvailable = UpdateProcessController.availableVersions.contains(robotOsVersion)
        showRobotCannotBeUpdated = !isUpdateProcessAvailable
    }

    private func updateShowRobotNeedsUpdate(robotOsVersion: String?) {
        if let robotOsVersion = robotOsVersion {
            let isUpdateProcessAvailable = UpdateProcessController.availableVersions.contains(robotOsVersion)
            let isRobotNeedsUpdate = globalFirmwareManager.compareWith(version: robotOsVersion) == .needsUpdate
            showRobotNeedsUpdate = isRobotNeedsUpdate && isUpdateProcessAvailable
        } else {
            showRobotNeedsUpdate = false
        }
    }
}
