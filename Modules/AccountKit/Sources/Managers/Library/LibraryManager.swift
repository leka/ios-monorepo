// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// swiftlint:disable type_body_length file_length

public class LibraryManager {
    // MARK: Lifecycle

    private init() {
        self.initializeLibraryListener()
    }

    // MARK: Public

    public static let shared = LibraryManager()

    public var currentLibrary = CurrentValueSubject<Library?, Never>(nil)
    public var savedActivities = CurrentValueSubject<[SavedActivity], Never>([])
    public var savedCurriculums = CurrentValueSubject<[SavedCurriculum], Never>([])
    public var savedStories = CurrentValueSubject<[SavedStory], Never>([])
    public let isLoading = PassthroughSubject<Bool, Never>()
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeLibraryListener() {
        self.dbOps.getCurrentLibrary()
            .handleLoadingState(using: self.isLoading)
            .handleEvents(receiveOutput: { [weak self] library in
                self?.subscribeToAllSubCollections(libraryID: library.id!)
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

    public func subscribeToAllSubCollections(libraryID: String) {
        self.dbOps.listenToAllLibrarySubCollections(libraryID: libraryID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error listening to sub-collections: \(error)")
                }
            }, receiveValue: { [weak self] curriculums, activities, stories in
                guard let self else { return }
                self.savedCurriculums.send(curriculums)
                self.savedActivities.send(activities)
                self.savedStories.send(stories)
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

    // MARK: - Curriculums

    public func addCurriculum(curriculumID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let newCurriculum = SavedCurriculum(
            id: curriculumID,
            caregiverID: caregiverID,
            addedAt: Date(),
            favoritedBy: [:]
        )

        self.dbOps.addItemToLibrarySubCollection(
            libraryID: libraryID,
            item: .curriculum(newCurriculum)
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

    public func removeCurriculum(curriculumID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeItemFromLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .curriculums,
            itemID: curriculumID
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

    public func addCurriculumToLibraryAsFavorite(curriculumID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let alreadyInTheLibrary: Bool = self.savedCurriculums.value.contains { $0.id == curriculumID }

        guard alreadyInTheLibrary else {
            let newCurriculum = SavedCurriculum(
                id: curriculumID,
                caregiverID: caregiverID,
                addedAt: Date(),
                favoritedBy: [caregiverID: Date()]
            )

            self.dbOps.addItemToLibrarySubCollection(
                libraryID: libraryID,
                item: .curriculum(newCurriculum)
            )
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: {
                log.info("Curriculum \(curriculumID) added and favorited successfully.")
            })
            .store(in: &self.cancellables)
            return
        }
        self.addSavedCurriculumToFavorites(curriculumID: curriculumID, caregiverID: caregiverID)
    }

    public func removeCurriculumFromFavorites(curriculumID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeLibraryItemFromFavorites(
            libraryID: libraryID,
            subCollection: .curriculums,
            itemID: curriculumID,
            caregiverID: caregiverID
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

    // MARK: - Activities + Gamepads

    public func addActivity(activityID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let newActivity = SavedActivity(
            id: activityID,
            caregiverID: caregiverID,
            addedAt: Date(),
            favoritedBy: [:]
        )
        self.dbOps.addItemToLibrarySubCollection(
            libraryID: libraryID,
            item: .activity(newActivity)
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
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeItemFromLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .activities,
            itemID: activityID
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

    public func addActivityToLibraryAsFavorite(activityID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let alreadyInTheLibrary: Bool = self.savedActivities.value.contains { $0.id == activityID }

        guard alreadyInTheLibrary else {
            let newActivity = SavedActivity(
                id: activityID,
                caregiverID: caregiverID,
                addedAt: Date(),
                favoritedBy: [caregiverID: Date()]
            )

            self.dbOps.addItemToLibrarySubCollection(
                libraryID: libraryID,
                item: .activity(newActivity)
            )
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: {
                log.info("Activity \(activityID) added and favorited successfully.")
            })
            .store(in: &self.cancellables)
            return
        }
        self.addSavedActivityToFavorites(activityID: activityID, caregiverID: caregiverID)
    }

    public func removeActivityFromFavorites(activityID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeLibraryItemFromFavorites(
            libraryID: libraryID,
            subCollection: .activities,
            itemID: activityID,
            caregiverID: caregiverID
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

    // MARK: - Stories

    public func addStory(storyID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let newStory = SavedStory(
            id: storyID,
            caregiverID: caregiverID,
            addedAt: Date(),
            favoritedBy: [:]
        )

        self.dbOps.addItemToLibrarySubCollection(
            libraryID: libraryID,
            item: .story(newStory)
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
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeItemFromLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .stories,
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

    public func addStoryToLibraryAsFavorite(storyID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let alreadyInTheLibrary: Bool = self.savedStories.value.contains { $0.id == storyID }

        guard alreadyInTheLibrary else {
            let newStory = SavedStory(
                id: storyID,
                caregiverID: caregiverID,
                addedAt: Date(),
                favoritedBy: [caregiverID: Date()]
            )

            self.dbOps.addItemToLibrarySubCollection(
                libraryID: libraryID,
                item: .story(newStory)
            )
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: {
                log.info("Story \(storyID) added and favorited successfully.")
            })
            .store(in: &self.cancellables)
            return
        }
        self.addSavedStoryToFavorites(storyID: storyID, caregiverID: caregiverID)
    }

    public func removeStoryFromFavorites(storyID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeLibraryItemFromFavorites(
            libraryID: libraryID,
            subCollection: .stories,
            itemID: storyID,
            caregiverID: caregiverID
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
        self.savedActivities.send([])
        self.savedCurriculums.send([])
        self.savedStories.send([])
        self.dbOps.clearAllListeners()
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    // MARK: Private

    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()

    private func addSavedCurriculumToFavorites(curriculumID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.addLibraryItemToFavorites(
            libraryID: libraryID,
            subCollection: .curriculums,
            itemID: curriculumID,
            caregiverID: caregiverID
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

    private func addSavedActivityToFavorites(activityID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.addLibraryItemToFavorites(
            libraryID: libraryID,
            subCollection: .activities,
            itemID: activityID,
            caregiverID: caregiverID
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

    private func addSavedStoryToFavorites(storyID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.addLibraryItemToFavorites(
            libraryID: libraryID,
            subCollection: .stories,
            itemID: storyID,
            caregiverID: caregiverID
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
}

// swiftlint:enable type_body_length file_length
