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
        case error
    }

    // MARK: - Private variables

    private var updateProcessController = UpdateProcessController()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public variables

    @Published public var updatingStatus: UpdateStatus = .sendingFile
    @Published public var sendingFileProgression: Float = 0.0

    @Published public var errorDescription: String = ""
    @Published public var errorInstruction: String = ""

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
        subscribeToStateUpdate()
        subscribeToSendingFileProgressionUpdate()
    }

    private func subscribeToStateUpdate() {
        self.updateProcessController.currentStage
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        self.updatingStatus = .updateFinished
                    case .failure(let error):
                        self.updatingStatus = .error

                        switch error {
                            case .failedToLoadFile:
                                self.errorDescription = "Impossible de charger le logiciel robot"
                                self.errorInstruction = "Réinstaller l'application"
                            case .robotNotUpToDate:
                                self.errorDescription = "Echec de la mise à jour"
                                self.errorInstruction = "Essayer à nouveau"
                            case .updateProcessNotAvailable:
                                self.errorDescription = "Le robot ne peut pas être mis à jour"
                                self.errorInstruction = "Contacter le support technique"
                            default:
                                self.errorDescription = "Erreur inconnue"
                                self.errorInstruction = "Contacter le support technique"
                        }
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

    private func subscribeToSendingFileProgressionUpdate() {
        self.updateProcessController.sendingFileProgression
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { progression in
                self.sendingFileProgression = progression
            })
            .store(in: &cancellables)
    }

    public func startUpdate() {
        updateProcessController.startUpdate()
    }

}
