// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit
import RobotKit
import SwiftUI

@Observable
class UpdateStatusViewModel {
    // MARK: Lifecycle

    init() {
        self.subscribeToStateUpdates()
        self.subscribeToSendingFileProgressionUpdates()
        self.subscribeToRobotIsChargingUpdates()
    }

    // MARK: Public

    // MARK: - Public variables

    public var updatingStatus: UpdateStatus = .sendingFile
    public var sendingFileProgression: Float = 0.0
    public var showAlert: Bool = false

    public var error: UpdateProcessError = .none
    public var errorInstructions: String = ""

    public var stepNumber: Int {
        switch self.updatingStatus {
            case .sendingFile:
                1
            case .rebootingRobot:
                2
            case .updateFinished:
                3
            case .error:
                -1
        }
    }

    public func startUpdate() {
        UIApplication.shared.isIdleTimerDisabled = true

        self.updateProcessController.startUpdate()
    }

    // MARK: Internal

    enum UpdateStatus {
        case sendingFile
        case rebootingRobot
        case updateFinished
        case error
    }

    // MARK: Private

    // MARK: - Private variables

    @ObservationIgnored
    private var updateProcessController = UpdateProcessController()

    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToStateUpdates() {
        self.updateProcessController.currentStage
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showAlert = false

                switch completion {
                    case .finished:
                        self.updatingStatus = .updateFinished
                    case let .failure(error):
                        self.updatingStatus = .error
                        self.error = error
                }
                self.onUpdateEnded()
            } receiveValue: { state in
                switch state {
                    case .initial,
                         .sendingUpdate:
                        self.updatingStatus = .sendingFile
                    case .installingUpdate:
                        self.updatingStatus = .rebootingRobot
                }
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToSendingFileProgressionUpdates() {
        self.updateProcessController.sendingFileProgression
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { progression in
                self.sendingFileProgression = progression
            })
            .store(in: &self.cancellables)
    }

    private func subscribeToRobotIsChargingUpdates() {
        Robot.shared.isCharging
            .receive(on: DispatchQueue.main)
            .sink { robotIsCharging in
                let robotShouldBeInCharge =
                    self.updatingStatus == .sendingFile || self.updatingStatus == .rebootingRobot

                self.showAlert = robotShouldBeInCharge && robotIsCharging == false
            }
            .store(in: &self.cancellables)
    }

    private func onUpdateEnded() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
