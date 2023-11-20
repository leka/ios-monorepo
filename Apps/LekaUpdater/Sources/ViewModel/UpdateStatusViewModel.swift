// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit
import SwiftUI

class UpdateStatusViewModel: ObservableObject {

    enum UpdateStatus {
        case sendingFile
        case rebootingRobot
        case updateFinished
        case error
    }

    // MARK: - Private variables

    private var updateProcessController = UpdateProcessController()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public variables

    @Published public var updatingStatus: UpdateStatus = .sendingFile
    @Published public var sendingFileProgression: Float = 0.0
    @Published public var showAlert: Bool = false

    @Published public var errorDescription: String = ""
    @Published public var errorInstructions: String = ""

    public var stepNumber: Int {
        switch updatingStatus {
            case .sendingFile:
                return 1
            case .rebootingRobot:
                return 2
            case .updateFinished:
                return 3
            case .error:
                return -1
        }
    }

    init() {
        subscribeToStateUpdates()
        subscribeToSendingFileProgressionUpdates()
        subscribeToRobotIsChargingUpdates()
    }

    private func subscribeToStateUpdates() {
        self.updateProcessController.currentStage
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showAlert = false

                switch completion {
                    case .finished:
                        self.updatingStatus = .updateFinished
                    case .failure(let error):
                        self.updatingStatus = .error

                        switch error {
                            case .failedToLoadFile:
                                self.errorDescription = String(l10n.update.error.failedToLoadFileDescription.characters)
                                self.errorInstructions = String(
                                    l10n.update.error.failedToLoadFileInstructions.characters)

                            case .robotNotUpToDate:
                                self.errorDescription = String(l10n.update.error.robotNotUpToDateDescription.characters)
                                self.errorInstructions = String(
                                    l10n.update.error.robotNotUpToDateInstructions.characters)

                            case .updateProcessNotAvailable:
                                self.errorDescription = String(
                                    l10n.update.error.updateProcessNotAvailableDescription.characters)
                                self.errorInstructions = String(
                                    l10n.update.error.updateProcessNotAvailableInstructions.characters)

                            case .robotUnexpectedDisconnection:
                                self.errorDescription = String(
                                    l10n.update.error.robotUnexpectedDisconnectionDescription.characters)
                                self.errorInstructions = String(
                                    l10n.update.error.robotUnexpectedDisconnectionInstructions.characters)

                            default:
                                self.errorDescription = String(l10n.update.error.unknownErrorDescription.characters)
                                self.errorInstructions = String(l10n.update.error.unknownErrorInstructions.characters)
                        }
                        self.onUpdateEnded()
                }
            } receiveValue: { state in
                switch state {
                    case .initial, .sendingUpdate:
                        self.updatingStatus = .sendingFile
                    case .installingUpdate:
                        self.updatingStatus = .rebootingRobot
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToSendingFileProgressionUpdates() {
        self.updateProcessController.sendingFileProgression
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { progression in
                self.sendingFileProgression = progression
            })
            .store(in: &cancellables)
    }

    private func subscribeToRobotIsChargingUpdates() {
        globalRobotManager.$isCharging
            .receive(on: DispatchQueue.main)
            .sink { robotIsCharging in
                let robotShouldBeInCharge =
                    self.updatingStatus == .sendingFile || self.updatingStatus == .rebootingRobot

                self.showAlert = robotShouldBeInCharge && robotIsCharging == false
            }
            .store(in: &cancellables)
    }

    public func startUpdate() {
        UIApplication.shared.isIdleTimerDisabled = true

        updateProcessController.startUpdate()
    }

    private func onUpdateEnded() {
        UIApplication.shared.isIdleTimerDisabled = false
    }

}
