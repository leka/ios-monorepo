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

    // MARK: Activities

    public func addSavedActivity(activityID: String, caregiverID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        let savedActivity = SavedActivity(id: activityID, caregiverID: caregiverID)

        guard !rootAccount.library.savedActivities.contains(where: { $0.id == activityID }) else {
            log.info("\(activityID) is already saved.")
            return
        }

        rootAccount.library.savedActivities.append(savedActivity)
        self.updateRootAccount(rootAccount: &rootAccount)
    }

    public func removeSavedActivity(activityID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        guard let index = rootAccount.library.savedActivities.firstIndex(where: { $0.id == activityID }) else {
            log.info("\(activityID) is not saved.")
            return
        }

        rootAccount.library.savedActivities.remove(at: index)
        self.updateRootAccount(rootAccount: &rootAccount)
    }

    // MARK: Curriculums

    public func addSavedCurriculum(curriculumID: String, caregiverID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        let savedCurriculum = SavedCurriculum(id: curriculumID, caregiverID: caregiverID)

        guard !rootAccount.library.savedCurriculums.contains(where: { $0.id == curriculumID }) else {
            log.info("\(curriculumID) is already saved.")
            return
        }

        rootAccount.library.savedCurriculums.append(savedCurriculum)
        self.updateRootAccount(rootAccount: &rootAccount)
    }

    public func removeSavedCurriculum(curriculumID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        guard let index = rootAccount.library.savedCurriculums.firstIndex(where: { $0.id == curriculumID }) else {
            log.info("\(curriculumID) is not saved.")
            return
        }

        rootAccount.library.savedCurriculums.remove(at: index)
        self.updateRootAccount(rootAccount: &rootAccount)
    }

    // MARK: Stories

    public func addSavedStory(storyID: String, caregiverID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        let savedStory = SavedStory(id: storyID, caregiverID: caregiverID)

        guard !rootAccount.library.savedStories.contains(where: { $0.id == storyID }) else {
            log.info("\(storyID) is already saved.")
            return
        }

        rootAccount.library.savedStories.append(savedStory)
        self.updateRootAccount(rootAccount: &rootAccount)
    }

    public func removeSavedStory(storyID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        guard let index = rootAccount.library.savedStories.firstIndex(where: { $0.id == storyID }) else {
            log.info("\(storyID) is not saved.")
            return
        }

        rootAccount.library.savedStories.remove(at: index)
        self.updateRootAccount(rootAccount: &rootAccount)
    }

    // MARK: Gamepads

    public func addSavedGamepad(gamepadID: String, caregiverID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        let savedGamepad = SavedGamepad(id: gamepadID, caregiverID: caregiverID)

        guard !rootAccount.library.savedGamepads.contains(where: { $0.id == gamepadID }) else {
            log.info("\(gamepadID) is already saved.")
            return
        }

        rootAccount.library.savedGamepads.append(savedGamepad)
        self.updateRootAccount(rootAccount: &rootAccount)
    }

    public func removeSavedGamepad(gamepadID: String) {
        guard var rootAccount = self.currentRootAccount.value else {
            self.fetchErrorSubject.send(DatabaseError.customError("RootAccount not found"))
            return
        }

        guard let index = rootAccount.library.savedGamepads.firstIndex(where: { $0.id == gamepadID }) else {
            log.info("\(gamepadID) is not saved.")
            return
        }

        rootAccount.library.savedGamepads.remove(at: index)
        self.updateRootAccount(rootAccount: &rootAccount)
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
