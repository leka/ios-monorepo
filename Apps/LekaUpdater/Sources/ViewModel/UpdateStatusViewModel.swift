// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

class UpdateStatusViewModel: ObservableObject {

    enum UpdateStatus {
        case sendingFile
        case rebootingRobot
        case updateFinished
    }

    // MARK: - Private variables

    private var updateProcessController = UpdateProcessController(robot: DummyRobotModel(osVersion: "1.0.0"))
    // TODO: Replace DummyRobotModel by RobotPeripheralViewModel

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public variables

    @Published public var updatingStatus: UpdateStatus = .sendingFile

    public var stepNumber: Int {
        switch updatingStatus {
            case .sendingFile:
                return 1
            case .rebootingRobot:
                return 2
            case .updateFinished:
                return 3
        }
    }

    init() {
        subscribeToStateUpdate()
    }

    private func subscribeToStateUpdate() {
        self.updateProcessController.currentStage
            .receive(on: DispatchQueue.main)
            .sink { completion in
                // TODO: Handle errors
                if completion == .finished {
                    self.updatingStatus = .updateFinished
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

    public func startUpdate() {
        updateProcessController.startUpdate()
    }

}
