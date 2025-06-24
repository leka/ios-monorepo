// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@Observable
public class RootAccountManagerViewModel {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    public var errorMessage: String = ""

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let rootAccountManager = RootAccountManager.shared

    private func subscribeToManager() {
        self.rootAccountManager.fetchErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                self?.handleError(error)
            })
            .store(in: &self.cancellables)
    }

    private func handleError(_ error: Error) {
        self.errorMessage = "An unknown error occurred: \(error.localizedDescription)"
    }
}
