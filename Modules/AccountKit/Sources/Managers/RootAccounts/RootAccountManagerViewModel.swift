// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class RootAccountManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    @Published public var savedActivities: [SavedActivity] = []
    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert: Bool = false
    @Published public var isLoading: Bool = false

    public func addSavedActivity(_ savedActivity: SavedActivity) {
        self.rootAccountManager.addSavedActivity(savedActivity)
    }

    public func removeSavedActivity(activityID: String, caregiverID _: String) {
        self.rootAccountManager.removeSavedActivity(activityID: activityID)
    }

    public func resetData() {
        self.rootAccountManager.resetData()
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let rootAccountManager = RootAccountManager.shared

    private func subscribeToManager() {
        self.rootAccountManager.currentRootAccountPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] rootAccount in
                self?.savedActivities = rootAccount?.savedActivities ?? []
            })
            .store(in: &self.cancellables)

        self.rootAccountManager.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                self?.isLoading = isLoading
            })
            .store(in: &self.cancellables)

        self.rootAccountManager.fetchErrorPublisher
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
                    if message == "User not authenticated" {
                        self.errorMessage = "Please log in to continue."
                    } else {
                        self.errorMessage = message
                    }
                case .documentNotFound:
                    self.errorMessage = "The requested data could not be found."
                case .decodeError:
                    self.errorMessage = "There was an error decoding the data."
                case .encodeError:
                    self.errorMessage = "There was an error encoding the data."
            }
        } else {
            self.errorMessage = "An unknown error occurred: \(error.localizedDescription)"
        }
        self.showErrorAlert = true
    }
}
