// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class LibraryManager {
    // MARK: Lifecycle

    private init() {
        self.initializeLibraryListener()
    }

    // MARK: Public

    public static let shared = LibraryManager()

    public var currentLibrary = CurrentValueSubject<Library?, Never>(nil)
    public let isLoading = PassthroughSubject<Bool, Never>()
    public var fetchError = PassthroughSubject<Error, Never>()

    public func initializeLibraryListener() {
        self.dbOps.getCurrentLibrary()
            .handleLoadingState(using: self.isLoading)
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

    // Useless now
    public func updateLibrary(_ library: Library) {
        let ignoredFields: [String] = ["root_owner_uid", "uuid", "created_at"]
        self.dbOps.update(data: library, in: .libraries, ignoringFields: ignoredFields)
            .handleLoadingState(using: self.isLoading)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.fetchError.send(error)
                }
            }, receiveValue: { [weak self] updatedLibrary in
                self?.currentLibrary.send(updatedLibrary)
                log.info("Library successfully updated.")
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
        guard var library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        guard let index = library.activities.firstIndex(where: { $0.id == activityID }) else {
            log.info("\(activityID) is not saved.")
            return
        }

        library.activities.remove(at: index)
        self.updateLibrary(library)
    }

    // MARK: - Curriculums

    public func addCurriculum(curriculumID: String, caregiverID: String) {
        guard let library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        let savedCurriculum = SavedCurriculum(id: curriculumID, caregiverID: caregiverID)

        self.dbOps.addItemToLibrary(
            documentID: library.id!,
            fieldName: .curriculums,
            newItem: savedCurriculum
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
        guard var library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        guard let index = library.curriculums.firstIndex(where: { $0.id == curriculumID }) else {
            log.info("\(curriculumID) is not saved.")
            return
        }

        library.curriculums.remove(at: index)
        self.updateLibrary(library)
    }

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
        guard var library = self.currentLibrary.value else {
            self.fetchError.send(DatabaseError.customError("Library not found"))
            return
        }

        guard let index = library.stories.firstIndex(where: { $0.id == storyID }) else {
            log.info("\(storyID) is not saved.")
            return
        }

        library.stories.remove(at: index)
        self.updateLibrary(library)
    }

    // MARK: - Reset Data

    public func resetData() {
        self.currentLibrary.send(nil)
        self.dbOps.clearAllListeners()
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    // MARK: Private

    private let dbOps = DatabaseOperations.shared
    private var cancellables = Set<AnyCancellable>()
}
