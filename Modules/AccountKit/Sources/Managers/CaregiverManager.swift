// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class CaregiverManager {
    // MARK: Lifecycle

    private init() {
        // Nothing to do
    }

    // MARK: Public

    public static let shared = CaregiverManager()

    public func fetchAllCaregivers() {
        self.dbOps.readAll(from: .caregivers)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] fetchedCaregivers in
                self?.caregiverList.send(fetchedCaregivers)
            })
            .store(in: &self.cancellables)
    }

    public func fetchCaregiver(documentID: String) {
        self.dbOps.read(from: .caregivers, documentID: documentID)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] fetchedCaregiver in
                self?.currentCaregiver.send(fetchedCaregiver)
            })
            .store(in: &self.cancellables)
    }

    public func addCaregiver(caregiver: Caregiver) {
        self.dbOps.create(data: caregiver, in: .caregivers)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchAllCaregivers()
            })
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    var caregiversPublisher: AnyPublisher<[Caregiver], Never> {
        self.caregiverList.eraseToAnyPublisher()
    }

    var currentCaregiverPublisher: AnyPublisher<Caregiver?, Never> {
        self.currentCaregiver.eraseToAnyPublisher()
    }

    var fetchErrorPublisher: AnyPublisher<Error, Never> {
        self.fetchErrorSubject.eraseToAnyPublisher()
    }

    // MARK: Private

    private var caregiverList = CurrentValueSubject<[Caregiver], Never>([])
    private var currentCaregiver = CurrentValueSubject<Caregiver?, Never>(nil)
    private var fetchErrorSubject = PassthroughSubject<Error, Never>()
    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
