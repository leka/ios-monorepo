// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import RobotKit
import Version

@Observable
class InformationViewModel {
    // MARK: Lifecycle

    init() {
        self.subscribeToRobotConnection()
        self.subscribeToRobotNameUpdates()
        self.subscribeToRobotOsVersionUpdates()
    }

    // MARK: Public

    public func onViewReappear() {
        self.robotName = Robot.shared.name.value
    }

    // MARK: Internal

    private(set) var isRobotConnected: Bool = false
    private(set) var showRobotCannotBeUpdated: Bool = false
    private(set) var showRobotNeedsUpdate: Bool = true
    private(set) var showRobotCanRollBack: Bool = false
    private(set) var robotName: String = "n/a"
    private(set) var robotOSVersion: String = ""

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToRobotConnection() {
        Robot.shared.isConnected
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                self.isRobotConnected = isConnected
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToRobotNameUpdates() {
        Robot.shared.name
            .receive(on: DispatchQueue.main)
            .sink { robotName in
                self.robotName = robotName
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToRobotOsVersionUpdates() {
        Robot.shared.osVersion
            .receive(on: DispatchQueue.main)
            .sink { robotOsVersion in
                self.updateShowRobotCannotBeUpdated(robotOsVersion: robotOsVersion)
                self.updateShowRobotNeedsUpdate(robotOsVersion: robotOsVersion)
                self.updateShowRobotCanRollBack(robotOsVersion: robotOsVersion)
                self.robotOSVersion = robotOsVersion?.description ?? "(n/a)"
            }
            .store(in: &self.cancellables)
    }

    private func updateShowRobotCannotBeUpdated(robotOsVersion: Version?) {
        guard let robotOsVersion else { return }

        let isUpdateProcessAvailable = UpdateProcessController.availableVersions.contains(robotOsVersion)
        self.showRobotCannotBeUpdated = !isUpdateProcessAvailable
    }

    private func updateShowRobotNeedsUpdate(robotOsVersion: Version?) {
        if let robotOsVersion {
            let isUpdateProcessAvailable = UpdateProcessController.availableVersions.contains(robotOsVersion)
            let isRobotNeedsUpdate = globalFirmwareManager.compareWith(version: robotOsVersion) == .needsUpdate
            self.showRobotNeedsUpdate = isRobotNeedsUpdate && isUpdateProcessAvailable
        } else {
            self.showRobotNeedsUpdate = false
        }
    }

    private func updateShowRobotCanRollBack(robotOsVersion: Version?) {
        if let robotOsVersion {
            let isUpdateProcessAvailable = UpdateProcessController.availableVersions.contains(robotOsVersion)
            let isRobotCanRollBack = globalFirmwareManager.compareWith(version: robotOsVersion) == .upToDate
            self.showRobotCanRollBack = isRobotCanRollBack && isUpdateProcessAvailable
        } else {
            self.showRobotCanRollBack = false
        }
    }
}
