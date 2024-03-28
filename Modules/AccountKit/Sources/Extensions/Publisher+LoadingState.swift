// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

extension Publisher {
    /// Adds loading state management to any Publisher.
    /// - Parameters:
    ///   - loadingStatePublisher: The `PassthroughSubject` used to publish loading state changes.
    /// - Returns: A Publisher that handles loading state updates.
    func handleLoadingState(using loadingStatePublisher: PassthroughSubject<Bool, Never>) -> AnyPublisher<Self.Output, Self.Failure> {
        self.handleEvents(
            receiveSubscription: { _ in loadingStatePublisher.send(true) },
            receiveOutput: { _ in loadingStatePublisher.send(false) },
            receiveCompletion: { _ in loadingStatePublisher.send(false) },
            receiveCancel: { loadingStatePublisher.send(false) }
        )
        .eraseToAnyPublisher()
    }
}
