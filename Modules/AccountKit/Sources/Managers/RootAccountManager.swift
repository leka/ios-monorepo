// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class RootAccountManager {
    // MARK: Lifecycle

    private init() {
        // Nothing to do
    }

    // MARK: Public

    public static let shared = RootAccountManager()

    public func createRootAccount(rootAccount: RootAccount) {
        self.dbOps.create(data: rootAccount, in: .rootAccounts)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.fetchErrorSubject.send(error)
                }
            }, receiveValue: { _ in
                // Deal with newly created RootAccount in the Back-Office
            })
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    var fetchErrorPublisher: AnyPublisher<Error, Never> {
        self.fetchErrorSubject.eraseToAnyPublisher()
    }

    // MARK: Private

    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()

    private var fetchErrorSubject = PassthroughSubject<Error, Never>()
}
