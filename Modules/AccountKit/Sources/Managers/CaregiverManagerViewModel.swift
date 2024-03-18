// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class CaregiverManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    @Published public var caregivers: [Caregiver] = []
    @Published public var currentCaregiver: Caregiver?
    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false

    @Published public var isLoading: Bool = false {
        didSet {
            print("Caregivers are Loading:", self.isLoading)
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let caregiverManager = CaregiverManager.shared

    private func subscribeToManager() {
        self.caregiverManager.caregiversPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fetchedCaregivers in
                self?.caregivers = fetchedCaregivers
            })
            .store(in: &self.cancellables)

        self.caregiverManager.currentCaregiverPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] caregiver in
                self?.currentCaregiver = caregiver
            })
            .store(in: &self.cancellables)

        self.caregiverManager.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &self.cancellables)

        self.caregiverManager.fetchErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                self?.handleError(error)
            })
            .store(in: &self.cancellables)
    }

    private func handleError(_ error: Error) {
        if let databaseError = error as? DatabaseError {
            switch databaseError {
                case let .customError(message):
                    self.errorMessage = message
                case .documentNotFound:
                    self.errorMessage = "The requested caregiver could not be found. Consider deleting this profile."
                case .decodeError:
                    self.errorMessage = "There was an error decoding the data."
                case .encodeError:
                    self.errorMessage = "There was an error encoding the data."
            }
        } else {
            self.errorMessage = "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
