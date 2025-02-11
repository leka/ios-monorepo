// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class LibraryManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    @Published public var currentLibrary: Library?
    @Published public var activities: [SavedActivity] = []
    @Published public var curriculums: [SavedCurriculum] = []
    @Published public var stories: [SavedStory] = []

    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert: Bool = false
    @Published public var isLoading: Bool = false

    public func isActivitySaved(activityID: String) -> Bool {
        self.activities.contains(where: { $0.id == activityID })
    }

    public func isCurriculumSaved(curriculumID: String) -> Bool {
        self.curriculums.contains(where: { $0.id == curriculumID })
    }

    public func isStorySaved(storyID: String) -> Bool {
        self.stories.contains(where: { $0.id == storyID })
    }

    public func isStoryFavorite(storyID: String) -> Bool {
        self.stories.first(where: { $0.id == storyID })?.isFavorite ?? false
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let libraryManager = LibraryManager.shared

    private func subscribeToManager() {
        self.libraryManager.currentLibrary
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] library in
                self?.currentLibrary = library
            })
            .store(in: &self.cancellables)

        self.libraryManager.savedCurriculums
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] curriculums in
                self?.curriculums = curriculums
            })
            .store(in: &self.cancellables)

        self.libraryManager.savedActivities
            .receive(on: RunLoop.main)
            .sink { [weak self] activities in
                self?.activities = activities
            }
            .store(in: &self.cancellables)

        self.libraryManager.savedStories
            .receive(on: RunLoop.main)
            .sink { [weak self] stories in
                self?.stories = stories
            }
            .store(in: &self.cancellables)

        self.libraryManager.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &self.cancellables)

        self.libraryManager.fetchError
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                self?.handleError(error)
            })
            .store(in: &self.cancellables)
    }

    private func handleError(_ error: Error) {
        if let databaseError = error as? DatabaseError {
            switch databaseError {
                case let .customError(message):
                    self.errorMessage = message
                case .documentNotFound:
                    self.errorMessage = "The requested library could not be found. Consider creating one."
                case .decodeError:
                    self.errorMessage = "There was an error decoding the library data."
                case .encodeError:
                    self.errorMessage = "There was an error encoding the library data."
            }
        } else {
            self.errorMessage = "An unknown error occurred: \(error.localizedDescription)"
        }
        self.showErrorAlert = true
    }
}
