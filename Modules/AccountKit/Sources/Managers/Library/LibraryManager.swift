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
    public var savedActivities = CurrentValueSubject<[SavedActivity], Never>([])
    public var savedCurriculums = CurrentValueSubject<[SavedCurriculum], Never>([])
    public var savedStories = CurrentValueSubject<[SavedStory], Never>([])
    public var favoriteActivities = CurrentValueSubject<[SavedActivity], Never>([])
    public let isLoading = PassthroughSubject<Bool, Never>()
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeLibraryListener() {
        self.dbOps.getCurrentLibrary()
            .handleLoadingState(using: self.isLoading)
            .handleEvents(receiveOutput: { [weak self] library in
                self?.subscribeToAllSubCollections(libraryID: library.id!)
                self?.subscribeToFavoriteActivitiesSubCollection(libraryID: library.id!)
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

        let newCurriculum = SavedCurriculum(id: curriculumID, caregiverID: caregiverID, addedAt: Date())

        self.dbOps.addItemToLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .curriculums,
            item: newCurriculum
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

    // MARK: - Activities + Gamepads

    public func addActivity(activityID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let newActivity = SavedActivity(id: activityID, caregiverID: caregiverID, addedAt: Date())

        self.dbOps.addItemToLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .activities,
            item: newActivity
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

//    public func removeActivity(activityID: String) {
//        guard let libraryID = currentLibrary.value?.id else {
//            self.fetchError.send(DatabaseError.customError("Library not found"))
//            return
//        }
//
//        self.dbOps.removeItemFromLibrarySubCollection(
//            libraryID: libraryID,
//            subCollection: .activities,
//            itemID: activityID
//        )
//        .sink(receiveCompletion: { [weak self] completion in
//            if case let .failure(error) = completion {
//                self?.fetchError.send(error)
//            }
//        }, receiveValue: {
//            // Nothing to do
//        })
//        .store(in: &self.cancellables)
//    }

    // MARK: - Stories

    public func addStory(asFavorite: Bool = false, storyID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let newStory = SavedStory(id: storyID, caregiverID: caregiverID, addedAt: Date(), isFavorite: asFavorite)

        self.dbOps.addItemToLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .stories,
            item: newStory
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

    public func toggleStoryFavoriteStatus(storyID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.toggleLibraryItemFavoriteStatus(
            libraryID: libraryID,
            subCollection: .stories,
            itemID: storyID
        )
        .sink(receiveCompletion: { [weak self] completion in
            if case let .failure(error) = completion {
                self?.fetchError.send(error)
            }
        }, receiveValue: {
            // Successfully updated favorite status
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
}

public extension LibraryManager {
    func subscribeToFavoriteActivitiesSubCollection(libraryID: String) {
        self.dbOps.listenToLibrarySubCollection(libraryID: libraryID, subCollection: .favoriteActivities)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error listening to sub-collection FAVORITE_ACTIVITIES: \(error)")
                }
            }, receiveValue: { [weak self] favoriteActivities in
                guard let self else { return }
                self.favoriteActivities.send(favoriteActivities)
            })
            .store(in: &self.cancellables)
    }

    func addActivityToFavorites(activityID: String, caregiverID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let newActivity = SavedActivity(id: activityID, caregiverID: caregiverID, addedAt: Date())

        if !self.savedActivities.value.contains(where: { $0.id == activityID }) {
            self.addActivity(activityID: activityID, caregiverID: caregiverID)
        }

        self.dbOps.addItemToLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .favoriteActivities,
            item: newActivity
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

    func removeActivityFromFavorites(activityID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        self.dbOps.removeItemFromLibrarySubCollection(
            libraryID: libraryID,
            subCollection: .favoriteActivities,
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

    func removeActivity(activityID: String) {
        guard let libraryID = currentLibrary.value?.id else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        if self.savedActivities.value.contains(where: { $0.id == activityID }) {
            self.removeActivityFromFavorites(activityID: activityID)
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
}
