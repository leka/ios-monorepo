// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import Combine

public class CarereceiverManager {
    // MARK: Lifecycle

    private init() {
        self.initializeCarereceiversListener()
    }

    // MARK: Public

    public static let shared = CarereceiverManager()

    public var carereceiverList = CurrentValueSubject<[Carereceiver], Never>([])
    public var currentCarereceivers = CurrentValueSubject<[Carereceiver], Never>([])
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeCarereceiversListener() {
        self.dbOps.observeAll(from: .carereceivers)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
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
                AnalyticsManager.logEventCarereceiverCreate(id: newCarereceiver.id!)
                log.info("Carereceiver \(newCarereceiver.id!) successfully created.")
            })
            .eraseToAnyPublisher()
    }

    public func updateCarereceiver(carereceiver: Carereceiver) {
        let ignoredFields: [String] = ["root_owner_uid", "uuid", "created_at"]
        self.dbOps.update(data: carereceiver, in: .carereceivers, ignoringFields: ignoredFields)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.fetchError.send(error)
                }
            }, receiveValue: { [weak self] updatedCarereceiver in
                guard let self else { return }
                AnalyticsManager.logEventCarereceiverEdit(carereceivers: updatedCarereceiver.id!)
                log.info("Carereceiver \(updatedCarereceiver.id!) successfully updated.")
            })
            .store(in: &self.cancellables)
    }

    public func deleteCarereceiver(documentID: String) {
        self.dbOps.delete(from: .carereceivers, documentID: documentID)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.fetchError.send(error)
                }
            }, receiveValue: {
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    public func setCurrentCarereceivers(to carereceivers: [Carereceiver]) {
        self.currentCarereceivers.send(carereceivers)
        let carereceiverIDs = carereceivers.compactMap(\.id)
        AnalyticsManager.logEventCarereceiversSelect(carereceivers: carereceiverIDs)
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
