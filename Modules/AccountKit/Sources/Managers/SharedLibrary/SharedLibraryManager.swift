// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// swiftlint:disable type_body_length file_length

public class SharedLibraryManager {
    // MARK: Lifecycle

    private init() {
        self.initializeSharedLibraryListener()
    }

    // MARK: Public

    public static let shared = SharedLibraryManager()

    public var currentSharedLibrary = CurrentValueSubject<SharedLibrary?, Never>(nil)
    public var savedActivities = CurrentValueSubject<[SavedActivity], Never>([])
    public var savedCurriculums = CurrentValueSubject<[SavedCurriculum], Never>([])
    public var savedStories = CurrentValueSubject<[SavedStory], Never>([])
    public let isLoading = PassthroughSubject<Bool, Never>()
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeSharedLibraryListener() {
        self.dbOps.getCurrentSharedLibrary()
            .handleLoadingState(using: self.isLoading)
            .handleEvents(receiveOutput: { [weak self] sharedLibrary in
                self?.subscribeToAllSubCollections(sharedLibraryID: sharedLibrary.id!)
            })
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        if case DatabaseError.documentNotFound = error {
                            self?.createSharedLibrary(library: SharedLibrary())
                        } else {
                            self?.fetchError.send(error)
                        }
                }
            }, receiveValue: { [weak self] sharedLibrary in
                guard let self else { return }
                self.currentSharedLibrary.send(sharedLibrary)
            })
            .store(in: &self.cancellables)
    }

    public func subscribeToAllSubCollections(sharedLibraryID: String) {
        self.dbOps.listenToAllSharedLibrarySubCollections(libraryID: sharedLibraryID)
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

    public func createSharedLibrary(library: SharedLibrary) {
        self.dbOps.create(data: library, in: .sharedLibraries)
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

    public func addCurriculum(curriculumID: String, name: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        let newCurriculum = SavedCurriculum(
            id: curriculumID,
            name: name,
            caregiverID: caregiverID,
            addedAt: Date(),
            favoritedBy: [:]
        )

        self.dbOps.addItemToSharedLibrarySubCollection(
            libraryID: sharedLibraryID,
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

    public func removeCurriculum(curriculumID: String, name _: String, caregiverID _: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.removeItemFromSharedLibrarySubCollection(
            libraryID: sharedLibraryID,
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

    public func addCurriculumToSharedLibraryAsFavorite(curriculumID: String, name: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        let alreadyInTheLibrary: Bool = self.savedCurriculums.value.contains { $0.id == curriculumID }

        guard alreadyInTheLibrary else {
            let newCurriculum = SavedCurriculum(
                id: curriculumID,
                name: name,
                caregiverID: caregiverID,
                addedAt: Date(),
                favoritedBy: [caregiverID: Date()]
            )

            self.dbOps.addItemToSharedLibrarySubCollection(
                libraryID: sharedLibraryID,
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
        self.addSavedCurriculumToFavorites(curriculumID: curriculumID, name: name, caregiverID: caregiverID)
    }

    public func removeCurriculumFromFavorites(curriculumID: String, name _: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.removeSharedLibraryItemFromFavorites(
            libraryID: sharedLibraryID,
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

    public func addActivity(activityID: String, name: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        let newActivity = SavedActivity(
            id: activityID,
            name: name,
            caregiverID: caregiverID,
            addedAt: Date(),
            favoritedBy: [:]
        )
        self.dbOps.addItemToSharedLibrarySubCollection(
            libraryID: sharedLibraryID,
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

    public func removeActivity(activityID: String, name _: String, caregiverID _: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeItemFromSharedLibrarySubCollection(
            libraryID: sharedLibraryID,
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

    public func addActivityToSharedLibraryAsFavorite(activityID: String, name: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let alreadyInTheLibrary: Bool = self.savedActivities.value.contains { $0.id == activityID }

        guard alreadyInTheLibrary else {
            let newActivity = SavedActivity(
                id: activityID,
                name: name,
                caregiverID: caregiverID,
                addedAt: Date(),
                favoritedBy: [caregiverID: Date()]
            )

            self.dbOps.addItemToSharedLibrarySubCollection(
                libraryID: sharedLibraryID,
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
        self.addSavedActivityToFavorites(activityID: activityID, name: name, caregiverID: caregiverID)
    }

    public func removeActivityFromFavorites(activityID: String, name _: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.removeSharedLibraryItemFromFavorites(
            libraryID: sharedLibraryID,
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

    public func addStory(storyID: String, name: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("SharedLibrary not found"))
            return
        }

        let newStory = SavedStory(
            id: storyID,
            name: name,
            caregiverID: caregiverID,
            addedAt: Date(),
            favoritedBy: [:]
        )

        self.dbOps.addItemToSharedLibrarySubCollection(
            libraryID: sharedLibraryID,
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

    public func removeStory(storyID: String, name _: String, caregiverID _: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.removeItemFromSharedLibrarySubCollection(
            libraryID: sharedLibraryID,
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

    public func addStoryToSharedLibraryAsFavorite(storyID: String, name: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        let alreadyInTheLibrary: Bool = self.savedStories.value.contains { $0.id == storyID }

        guard alreadyInTheLibrary else {
            let newStory = SavedStory(
                id: storyID,
                name: name,
                caregiverID: caregiverID,
                addedAt: Date(),
                favoritedBy: [caregiverID: Date()]
            )

            self.dbOps.addItemToSharedLibrarySubCollection(
                libraryID: sharedLibraryID,
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
        self.addSavedStoryToFavorites(storyID: storyID, name: name, caregiverID: caregiverID)
    }

    public func removeStoryFromFavorites(storyID: String, name _: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.removeSharedLibraryItemFromFavorites(
            libraryID: sharedLibraryID,
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
        self.currentSharedLibrary.send(nil)
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

    private func addSavedCurriculumToFavorites(curriculumID: String, name _: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.addSharedLibraryItemToFavorites(
            libraryID: sharedLibraryID,
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

    private func addSavedActivityToFavorites(activityID: String, name _: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.addSharedLibraryItemToFavorites(
            libraryID: sharedLibraryID,
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

    private func addSavedStoryToFavorites(storyID: String, name _: String, caregiverID: String) {
        guard let sharedLibraryID = currentSharedLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Shared Library not found"))
            return
        }

        self.dbOps.addSharedLibraryItemToFavorites(
            libraryID: sharedLibraryID,
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
