// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class CaregiverManager {
    // MARK: Lifecycle

    private init() {
        self.initializeCaregiversListener()
    }

    // MARK: Public

    public static let shared = CaregiverManager()

    public var caregiverList = CurrentValueSubject<[Caregiver], Never>([])
    public var currentCaregiver = CurrentValueSubject<Caregiver?, Never>(nil)
    public let isLoading = PassthroughSubject<Bool, Never>()
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeCaregiversListener() {
        self.dbOps.observeAll(from: .caregivers)
            .handleLoadingState(using: self.isLoading)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: { [weak self] fetchedCaregivers in
                guard let self else { return }
                self.caregiverList.send(fetchedCaregivers)
                if let currentID = self.currentCaregiver.value?.id {
                    self.currentCaregiver.send(fetchedCaregivers.first { $0.id == currentID })
                }
            })
            .store(in: &self.cancellables)
    }

    public func fetchCaregiver(documentID: String) {
        self.dbOps.read(from: .caregivers, documentID: documentID)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: { [weak self] fetchedCaregiver in
                self?.currentCaregiver.send(fetchedCaregiver)
            })
            .store(in: &self.cancellables)
    }

    public func createCaregiver(caregiver: Caregiver) -> AnyPublisher<Caregiver, Error> {
        self.dbOps.create(data: caregiver, in: .caregivers)
            .flatMap { [weak self] createdCaregiver -> AnyPublisher<Caregiver, Error> in
                guard self != nil else {
                    return Fail(error: DatabaseError.customError("Unexpected Nil Value")).eraseToAnyPublisher()
                }

                return Just(createdCaregiver)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.initializeCaregiversListener()
            })
            .eraseToAnyPublisher()
    }

    public func updateCaregiver(caregiver: inout Caregiver) {
        caregiver.lastEditedAt = nil
        self.dbOps.update(data: caregiver, in: .caregivers)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.fetchError.send(error)
                }
            }, receiveValue: { _ in
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    public func deleteCaregiver(documentID: String) {
        self.dbOps.delete(from: .caregivers, documentID: documentID)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.fetchError.send(error)
                }
            }, receiveValue: {
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    public func setCurrentCaregiver(to caregiver: Caregiver) {
        self.currentCaregiver.send(caregiver)
    }

    public func setCurrentCaregiver(byID id: String) {
        self.currentCaregiver.send(self.caregiverList.value.first { $0.id == id })
    }

    public func resetCurrentCaregiver() {
        self.currentCaregiver.send(nil)
    }

    public func resetData() {
        self.currentCaregiver.send(nil)
        self.caregiverList.send([])
        self.dbOps.clearAllListeners()
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    // MARK: Private

    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
