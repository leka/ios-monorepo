// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class ActivityCompletionDataManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    @Published public var activityCompletionDataList: [ActivityCompletionData] = []
    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let activityCompletionDataManager = ActivityCompletionDataManager.shared

    private func subscribeToManager() {
        self.activityCompletionDataManager.activityCompletionDataList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fetchedData in
                self?.activityCompletionDataList = fetchedData
            })
            .store(in: &self.cancellables)

        self.activityCompletionDataManager.fetchErrorPublisher
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
                    self.errorMessage = "The requested data could not be found."
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
