// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class CaregiversManager {
    // MARK: Lifecycle

    public init(databaseOperations: DatabaseOperations) {
        self.databaseOperations = databaseOperations
    }

    // MARK: Public

    public func fetchCaregiverDetails(caregiverID: String) -> AnyPublisher<Caregiver, Error> {
        self.databaseOperations.read(from: .caregivers, documentID: caregiverID)
    }

    public func createCaregiver(_ caregiver: Caregiver) -> AnyPublisher<Caregiver, Error> {
        self.databaseOperations.create(data: caregiver, in: .caregivers)
    }

    public func updateCaregiver(_ caregiver: Caregiver, caregiverID: String) -> AnyPublisher<Void, Error> {
        self.databaseOperations.update(data: caregiver, in: .caregivers, documentID: caregiverID)
    }

    public func deleteCaregiver(caregiverID: String) -> AnyPublisher<Void, Error> {
        self.databaseOperations.delete(from: .caregivers, documentID: caregiverID)
    }

    // MARK: Private

    private var databaseOperations: DatabaseOperations
    private var cancellables = Set<AnyCancellable>()
}
