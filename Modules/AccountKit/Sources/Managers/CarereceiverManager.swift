// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class CarereceiverManager {
    // MARK: Lifecycle

    private init() {
        self.initializeCarereceiversListener()
    }

    // MARK: Public

    public static let shared = CarereceiverManager()

    public func initializeCarereceiversListener() {
        self.dbOps.observeAll(from: .carereceivers)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] fetchedCarereceivers in
                self?.carereceiverList.send(fetchedCarereceivers)
            })
            .store(in: &self.cancellables)
    }

    public func createCarereceiver(carereceiver: Carereceiver) -> AnyPublisher<Carereceiver, Error> {
        self.dbOps.create(data: carereceiver, in: .carereceivers)
            .flatMap { [weak self] createdCarereceiver -> AnyPublisher<Carereceiver, Error> in
                guard self != nil else {
                    return Fail(error: DatabaseError.customError("Unexpected Nil Value")).eraseToAnyPublisher()
                }

                return Just(createdCarereceiver)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.initializeCarereceiversListener()
            })
            .eraseToAnyPublisher()
    }

    public func updateCarereceiver(carereceiver: inout Carereceiver) {
        carereceiver.lastEditedAt = nil
        self.dbOps.update(data: carereceiver, in: .carereceivers)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.fetchErrorSubject.send(error)
                }
            }, receiveValue: {
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    public func deleteCarereceiver(documentID: String) {
        self.dbOps.delete(from: .carereceivers, documentID: documentID)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.fetchErrorSubject.send(error)
                }
            }, receiveValue: {
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    public func setCurrentCarereceivers(to carereceivers: [Carereceiver]) {
        self.currentCarereceivers.send(carereceivers)
    }

    public func resetData() {
        self.currentCarereceivers.send([])
        self.carereceiverList.send([])
        self.dbOps.clearAllListeners()
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    // MARK: Internal

    var carereceiversPublisher: AnyPublisher<[Carereceiver], Never> {
        self.carereceiverList.eraseToAnyPublisher()
    }

    var currentCarereceiversPublisher: AnyPublisher<[Carereceiver], Never> {
        self.currentCarereceivers.eraseToAnyPublisher()
    }

    var fetchErrorPublisher: AnyPublisher<Error, Never> {
        self.fetchErrorSubject.eraseToAnyPublisher()
    }

    // MARK: Private

    private var carereceiverList = CurrentValueSubject<[Carereceiver], Never>([])
    private var currentCarereceivers = CurrentValueSubject<[Carereceiver], Never>([])
    private var fetchErrorSubject = PassthroughSubject<Error, Never>()
    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
