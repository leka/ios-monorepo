// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class CarereceiverManager {
    // MARK: Lifecycle

    private init() {
        // Nothing to do
    }

    // MARK: Public

    public static let shared = CarereceiverManager()

    public func fetchAllCarereceivers() {
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

    public func fetchCarereceiver(documentID: String) {
        self.dbOps.read(from: .carereceivers, documentID: documentID)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] fetchedCarereceiver in
                self?.currentCarereceiver.send(fetchedCarereceiver)
            })
            .store(in: &self.cancellables)
    }

    public func addCarereceiver(carereceiver: Carereceiver) {
        self.dbOps.create(data: carereceiver, in: .carereceivers)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { _ in
                self.fetchAllCarereceivers()
            })
            .store(in: &self.cancellables)
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

    public func setCurrentCarereceiver(to carereceiver: Carereceiver) {
        self.currentCarereceiver.send(carereceiver)
    }

    public func resetData() {
        self.currentCarereceiver.send(nil)
        self.carereceiverList.send([])
    }

    // MARK: Internal

    var carereceiversPublisher: AnyPublisher<[Carereceiver], Never> {
        self.carereceiverList.eraseToAnyPublisher()
    }

    var currentCarereceiverPublisher: AnyPublisher<Carereceiver?, Never> {
        self.currentCarereceiver.eraseToAnyPublisher()
    }

    var fetchErrorPublisher: AnyPublisher<Error, Never> {
        self.fetchErrorSubject.eraseToAnyPublisher()
    }

    // MARK: Private

    private var carereceiverList = CurrentValueSubject<[Carereceiver], Never>([])
    private var currentCarereceiver = CurrentValueSubject<Carereceiver?, Never>(nil)
    private var fetchErrorSubject = PassthroughSubject<Error, Never>()
    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
