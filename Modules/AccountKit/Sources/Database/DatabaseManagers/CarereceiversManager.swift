// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class CareReceiversManager {
    // MARK: Lifecycle

    public init(databaseOperations: DatabaseOperations) {
        self.databaseOperations = databaseOperations
    }

    // MARK: Public

    public func fetchCarereceiverDetails(carereceiverID: String) -> AnyPublisher<Carereceiver, Error> {
        self.databaseOperations.read(from: .carereceivers, documentID: carereceiverID)
    }

    public func createCarereceiver(_ carereceiver: Carereceiver) -> AnyPublisher<Carereceiver, Error> {
        self.databaseOperations.create(data: carereceiver, in: .carereceivers)
    }

    public func updateCarereceiver(_ carereceiver: Carereceiver, carereceiverID: String) -> AnyPublisher<Void, Error> {
        self.databaseOperations.update(data: carereceiver, in: .carereceivers, documentID: carereceiverID)
    }

    public func deleteCarereceiver(carereceiverID: String) -> AnyPublisher<Void, Error> {
        self.databaseOperations.delete(from: .carereceivers, documentID: carereceiverID)
    }

    // MARK: Private

    private var databaseOperations: DatabaseOperations
    private var cancellables = Set<AnyCancellable>()
}
