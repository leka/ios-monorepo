// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - LibraryManager

public class LibraryManager {
    // MARK: Lifecycle

    private init() {
        self.initializeLibraryListener()
    }

    // MARK: Public

    public static let shared = LibraryManager()

    public var currentLibrary = CurrentValueSubject<Library?, Never>(nil)
    public var savedCurriculums = CurrentValueSubject<[SavedCurriculum], Never>([])
    public let isLoading = PassthroughSubject<Bool, Never>()
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeLibraryListener() {
        self.dbOps.getCurrentLibrary()
            .handleLoadingState(using: self.isLoading)
            .handleEvents(receiveOutput: { [weak self] library in
                self?.setupCurriculumListener(for: library.id!)
            })
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        if case DatabaseError.documentNotFound = error {
                            self?.createLibrary(library: Library())
                        } else {
                            self?.fetchError.send(error)
                        }
                }
            }, receiveValue: { [weak self] library in
                guard let self else { return }
                self.currentLibrary.send(library)
            })
            .store(in: &self.cancellables)
    }

    public func createLibrary(library: Library) {
        self.dbOps.create(data: library, in: .libraries)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: { _ in
                // Handle successful creation if needed
            })
            .store(in: &self.cancellables)
    }

    public func addActivity(activityID: String, caregiverID: String) {
        guard let library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let savedActivity = SavedActivity(id: activityID, caregiverID: caregiverID)

        self.dbOps.addItemToLibrary(
            documentID: library.id!,
            fieldName: .activities,
            newItem: savedActivity
        )
        .sink(receiveCompletion: { [weak self] completion in
            if case let .failure(error) = completion {
                self?.fetchError.send(error)
            }
        }, receiveValue: {
            // Nothing to do
        })
        .store(in: &self.cancellables)
    }

    public func removeActivity(activityID: String) {
        guard let library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        guard let activityToRemove = library.activities.first(where: { $0.id == activityID }) else {
            log.info("Activity \(activityID) is not in the library.")
            return
        }

        let savedActivity = SavedActivity(id: activityToRemove.id, caregiverID: activityToRemove.caregiverID, addedAt: activityToRemove.addedAt)

        self.dbOps.removeItemWithStringDateFromLibrary(
            documentID: library.id!,
            fieldName: .activities,
            valueToRemove: savedActivity
        )
        .sink(receiveCompletion: { [weak self] completion in
            if case let .failure(error) = completion {
                self?.fetchError.send(error)
            }
        }, receiveValue: {
            // Nothing to do
        })
        .store(in: &self.cancellables)
    }

    // MARK: - Curriculums

    // cf extension below

    // MARK: - Stories

    public func addStory(storyID: String, caregiverID: String) {
        guard let library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let savedStory = SavedStory(id: storyID, caregiverID: caregiverID)

        self.dbOps.addItemToLibrary(
            documentID: library.id!,
            fieldName: .stories,
            newItem: savedStory
        )
        .sink(receiveCompletion: { [weak self] completion in
            if case let .failure(error) = completion {
                self?.fetchError.send(error)
            }
        }, receiveValue: {
            // Nothing to do
        })
        .store(in: &self.cancellables)
    }

    public func removeStory(storyID: String) {
        guard let library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeItemFromLibrary(
            documentID: library.id!,
            fieldName: .stories,
            itemID: storyID
        )
        .sink(receiveCompletion: { [weak self] completion in
            if case let .failure(error) = completion {
                self?.fetchError.send(error)
            }
        }, receiveValue: {
            // Nothing to do
        })
        .store(in: &self.cancellables)
    }

    // MARK: - Reset Data

    public func resetData() {
        self.currentLibrary.send(nil)
        self.savedCurriculums.send([])
        self.dbOps.clearAllListeners()
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    // MARK: Private

    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}

public extension LibraryManager {
    func setupCurriculumListener(for libraryID: String) {
        self.dbOps.listenToCurriculums(libraryID: libraryID)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case let .failure(error):
                        print("Error received: \(error)")
                    case .finished:
                        break
                }
            }, receiveValue: { [weak self] curriculums in
                guard let self else { return }
                self.savedCurriculums.send(curriculums)
            })
            .store(in: &self.cancellables)
    }

    func addCurriculum(curriculumID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let newCurriculum = SavedCurriculum(id: curriculumID, caregiverID: caregiverID, addedAt: Date())

        self.dbOps.addCurriculumToLibrary(libraryID: libraryID, curriculum: newCurriculum)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: {
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }

    func removeCurriculum(curriculumID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeCurriculumFromLibrary(libraryID: libraryID, curriculumID: curriculumID)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: {
                // Nothing to do
            })
            .store(in: &self.cancellables)
    }
}
