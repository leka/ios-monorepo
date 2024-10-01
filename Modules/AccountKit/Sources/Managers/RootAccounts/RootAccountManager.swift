// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class RootAccountManager {
    // MARK: Lifecycle

    private init() {
        self.initializeRootAccountListener()
    }

    // MARK: Public

    public static let shared = RootAccountManager()

    public func initializeRootAccountListener() {
        self.dbOps.getCurrentRootAccount()
            .handleLoadingState(using: self.loadingStatePublisher)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] rootAccount in
                guard let self else { return }
                self.currentRootAccount.send(rootAccount)
            })
            .store(in: &self.cancellables)
    }

    public func createRootAccount(rootAccount: RootAccount) {
        self.dbOps.create(data: rootAccount, in: .rootAccounts)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchErrorSubject.send(error)
                }
            }, receiveValue: { _ in
                // Handle successful creation from within the dashboard if needed
            })
            .store(in: &self.cancellables)
    }

    public func updateRootAccount(rootAccount: inout RootAccount) {
        rootAccount.lastEditedAt = nil
        self.dbOps.update(data: rootAccount, in: .rootAccounts)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.fetchErrorSubject.send(error)
                    }
                },
                receiveValue: { _ in
                    // Successfully updated
                }
            )
            .store(in: &self.cancellables)
    }

    public func addSavedActivity(_ savedActivity: SavedActivity) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        if !rootAccount.savedActivities.contains(where: { $0.id == savedActivity.id }) {
            rootAccount.savedActivities.append(savedActivity)
            self.updateRootAccount(rootAccount: &rootAccount)
        } else {
            log.info("The activity \(String(describing: savedActivity.id)) has already been saved by \(savedActivity.caregiverID).")
        }
    }

    public func removeSavedActivity(activityID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        if let index = rootAccount.savedActivities.firstIndex(where: { $0.id == activityID }) {
            rootAccount.savedActivities.remove(at: index)
            self.updateRootAccount(rootAccount: &rootAccount)
        }
    }

    public func resetData() {
        self.currentRootAccount.send(nil)
        self.dbOps.clearAllListeners()
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    // MARK: Internal

    var currentRootAccountPublisher: AnyPublisher<RootAccount?, Never> {
        self.currentRootAccount.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        self.loadingStatePublisher.eraseToAnyPublisher()
    }

    var fetchErrorPublisher: AnyPublisher<Error, Never> {
        self.fetchErrorSubject.eraseToAnyPublisher()
    }

    // MARK: Private

    private var currentRootAccount = CurrentValueSubject<RootAccount?, Never>(nil)
    private let loadingStatePublisher = PassthroughSubject<Bool, Never>()
    private let fetchErrorSubject = PassthroughSubject<Error, Never>()
    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
