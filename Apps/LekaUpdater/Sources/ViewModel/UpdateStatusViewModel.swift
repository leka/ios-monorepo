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
                                self.errorDescription = """
                                    Le fichier de mise à jour du robot ne peut pas être ouvert
                                    (Code erreur #0001)
                                    """
                                self.errorInstruction = "Veuillez réinstaller l'application"
                            case .robotNotUpToDate:
                                self.errorDescription = """
                                    Echec de la mise à jour
                                    (Code erreur #0002)
                                    """
                                self.errorInstruction = "Reconnectez le robot et relancez le processus"
                            case .updateProcessNotAvailable:
                                self.errorDescription = """
                                    Processus de mise à jour non disponible ou inconnu
                                    (Code erreur #0003)
                                    """
                                self.errorInstruction = "Contactez le support technique"
                            default:
                                self.errorDescription = """
                                    Une erreur inconnue s'est produite
                                    (Code erreur #0000)
                                    """
                                self.errorInstruction = "Contactez le support technique"
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
