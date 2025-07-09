// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// swiftlint:disable identifier_name nesting

public class CarereceiverManager {
    // MARK: Lifecycle

    private init() {
        self.initializeCarereceiversListener()
    }

    // MARK: Public

    public enum Event {
        case didCreateCarereceiver(id: String)
        case didUpdateCarereceiver(id: String)
        case didSelectCarereceivers(ids: [String])
    }

    public static let shared = CarereceiverManager()

    public var eventPublisher = PassthroughSubject<Event, Never>()

    public var carereceiverList = CurrentValueSubject<[Carereceiver], Never>([])
    public var currentCarereceivers = CurrentValueSubject<[Carereceiver], Never>([])
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeCarereceiversListener() {
        self.dbOps.observeAll(from: .carereceivers)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    log.error("There was an error while initializing carereceivers listener: \(error)")
                    self?.fetchError.send(error)
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
            .handleEvents(receiveOutput: { [weak self] newCarereceiver in
                self?.initializeCarereceiversListener()
                self?.eventPublisher.send(.didCreateCarereceiver(id: newCarereceiver.id!))
                log.info("Carereceiver \(newCarereceiver.id!) successfully created.")
            })
            .eraseToAnyPublisher()
    }

    public func updateCarereceiver(carereceiver: Carereceiver) {
        let carereceiverData: [String: Any] = [
            Carereceiver.CodingKeys.username.rawValue: carereceiver.username,
            Carereceiver.CodingKeys.avatar.rawValue: carereceiver.avatar,
            Carereceiver.CodingKeys.reinforcer.rawValue: carereceiver.reinforcer.stringValue,
        ]

        self.dbOps.update(id: carereceiver.id!, data: carereceiverData, collection: .carereceivers)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    log.error("There was an error while updating carereceiver \(carereceiver.id!): \(error)")
                    self.fetchError.send(error)
                }
            }, receiveValue: { _ in
                self.eventPublisher.send(.didUpdateCarereceiver(id: carereceiver.id!))
                log.info("Carereceiver \(carereceiver.id!) successfully updated.")
            })
            .store(in: &self.cancellables)
    }

    public func deleteCarereceiver(documentID: String) {
        self.dbOps.delete(from: .carereceivers, documentID: documentID)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    log.error("There was an error while deleting carereceiver \(documentID): \(error)")
                    self.fetchError.send(error)
                }
            }, receiveValue: {
                log.info("Carereceiver \(documentID) successfully deleted.")
            })
            .store(in: &self.cancellables)
    }

    public func setCurrentCarereceivers(to carereceivers: [Carereceiver]) {
        self.currentCarereceivers.send(carereceivers)
        let carereceiverIDs = carereceivers.compactMap(\.id)
        self.eventPublisher.send(.didSelectCarereceivers(ids: carereceiverIDs))
    }

    public func resetData() {
        self.currentCarereceivers.send([])
        self.carereceiverList.send([])
        self.dbOps.clearAllListeners()
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    // MARK: Private

    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}

// swiftlint:enable identifier_name nesting
