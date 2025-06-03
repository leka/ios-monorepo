// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@Observable
public class CarereceiverManagerViewModel {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    public private(set) var carereceivers: [Carereceiver] = []
    public private(set) var currentCarereceivers: [Carereceiver] = []
    public var showErrorAlert = false

    // MARK: Private

    private let carereceiverManager = CarereceiverManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var errorMessage: String = ""

    private func subscribeToManager() {
        self.carereceiverManager.carereceiverList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fetchedCarereceivers in
                self?.carereceivers = fetchedCarereceivers
            })
            .store(in: &self.cancellables)

        self.carereceiverManager.currentCarereceivers
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fetchedCarereceivers in
                self?.currentCarereceivers = fetchedCarereceivers
            })
            .store(in: &self.cancellables)

        self.carereceiverManager.fetchError
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
                    self.errorMessage = "The requested carereceiver could not be found. Consider deleting this profile."
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
