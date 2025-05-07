// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Observation
import SwiftUI

// MARK: - LibraryManagerViewModel

@Observable
public class LibraryManagerViewModel {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    public enum RemoveAlertType {
        case none
        case confirmPersonalFavorite
        case informOthersFavorited
    }

    public static let shared = LibraryManagerViewModel()

    public var currentLibrary: Library?
    public var activities: [SavedActivity] = []
    public var curriculums: [SavedCurriculum] = []
    public var stories: [SavedStory] = []

    public var errorMessage: String = ""
    public var showErrorAlert: Bool = false
    public var isLoading: Bool = false

    // Alert-related properties
    public var showRemoveAlert: Bool = false
    public var alertType: RemoveAlertType = .none
    public var itemToRemove: LibraryItem?

    public func isContentSaved(id: String) -> Bool {
        self.activities.contains { $0.id == id } ||
            self.curriculums.contains { $0.id == id } ||
            self.stories.contains { $0.id == id }
    }

    public func isContentFavorited(by caregiver: String, contentID: String) -> Bool {
        if let activity = self.activities.first(where: { $0.id == contentID }) {
            activity.favoritedBy.keys.contains(caregiver)
        } else if let curriculum = self.curriculums.first(where: { $0.id == contentID }) {
            curriculum.favoritedBy.keys.contains(caregiver)
        } else if let story = self.stories.first(where: { $0.id == contentID }) {
            story.favoritedBy.keys.contains(caregiver)
        } else {
            false
        }
    }

    // Activities

    public func isActivitySaved(activityID: String) -> Bool {
        self.activities.contains { $0.id == activityID }
    }

    public func isActivityFavoritedByCurrentCaregiver(activityID: String, caregiverID: String) -> Bool {
        guard let activity = self.activities.first(where: { $0.id == activityID }) else { return false }
        return activity.favoritedBy.keys.contains(caregiverID)
    }

    // Curriculums

    public func isCurriculumSaved(curriculumID: String) -> Bool {
        self.curriculums.contains { $0.id == curriculumID }
    }

    public func isCurriculumFavoritedByCurrentCaregiver(curriculumID: String, caregiverID: String) -> Bool {
        guard let curriculum = self.curriculums.first(where: { $0.id == curriculumID }) else { return false }
        return curriculum.favoritedBy.keys.contains(caregiverID)
    }

    // Stories

    public func isStorySaved(storyID: String) -> Bool {
        self.stories.contains { $0.id == storyID }
    }

    public func isStoryFavoritedByCurrentCaregiver(storyID: String, caregiverID: String) -> Bool {
        guard let story = self.stories.first(where: { $0.id == storyID }) else { return false }
        return story.favoritedBy.keys.contains(caregiverID)
    }

    // MARK: Private

    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private let libraryManager = LibraryManager.shared

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

public extension LibraryManagerViewModel {
    func addItemToLibrary(_ item: LibraryItem) {
        switch item {
            case let .activity(activity):
                self.libraryManager.addActivity(
                    activityID: activity.id,
                    caregiverID: activity.caregiverID
                )
            case let .curriculum(curriculum):
                self.libraryManager.addCurriculum(
                    curriculumID: curriculum.id,
                    caregiverID: curriculum.caregiverID
                )
            case let .story(story):
                self.libraryManager.addStory(
                    storyID: story.id,
                    caregiverID: story.caregiverID
                )
        }
    }

    func addItemToFavorite(_ item: LibraryItem) {
        switch item {
            case let .activity(activity):
                self.libraryManager.addActivityToLibraryAsFavorite(
                    activityID: activity.id,
                    caregiverID: activity.caregiverID
                )
            case let .curriculum(curriculum):
                self.libraryManager.addCurriculumToLibraryAsFavorite(
                    curriculumID: curriculum.id,
                    caregiverID: curriculum.caregiverID
                )
            case let .story(story):
                self.libraryManager.addStoryToLibraryAsFavorite(
                    storyID: story.id,
                    caregiverID: story.caregiverID
                )
        }
    }

    func requestItemRemoval(_ item: LibraryItem, caregiverID: String) {
        if self.isItemFavoritedByOthers(item: item, caregiverID: caregiverID) {
            self.alertType = .informOthersFavorited
        } else if self.isItemFavoritedByCurrentCaregiver(item: item, caregiverID: caregiverID),
                  self.getFavoritingCaregivers(for: item).count == 1
        {
            self.alertType = .confirmPersonalFavorite
        } else {
            self.removeItemFromLibrary(item)
            return
        }

        self.itemToRemove = item
        self.showRemoveAlert = true
    }

    func removeItemFromLibrary(_ item: LibraryItem) {
        switch item {
            case let .activity(activity):
                self.libraryManager.removeActivity(activityID: activity.id)
            case let .curriculum(curriculum):
                self.libraryManager.removeCurriculum(curriculumID: curriculum.id)
            case let .story(story):
                self.libraryManager.removeStory(storyID: story.id)
        }

        self.itemToRemove = nil
        self.showRemoveAlert = false
    }

    func removeItemFromFavorites(_ item: LibraryItem) {
        switch item {
            case let .activity(activity):
                self.libraryManager.removeActivityFromFavorites(activityID: activity.id, caregiverID: activity.caregiverID)
            case let .curriculum(curriculum):
                self.libraryManager.removeCurriculumFromFavorites(curriculumID: curriculum.id, caregiverID: curriculum.caregiverID)
            case let .story(story):
                self.libraryManager.removeStoryFromFavorites(storyID: story.id, caregiverID: story.caregiverID)
        }

        self.itemToRemove = nil
        self.showRemoveAlert = false
    }

    // MARK: - Favorite Status Checks

    private func isItemFavoritedByCurrentCaregiver(item: LibraryItem, caregiverID: String) -> Bool {
        let favoritingCaregivers = self.getFavoritingCaregivers(for: item)
        return favoritingCaregivers.contains(caregiverID)
    }

    private func isItemFavoritedByOthers(item: LibraryItem, caregiverID: String) -> Bool {
        let favoritingCaregivers = self.getFavoritingCaregivers(for: item)
        return favoritingCaregivers.contains(where: { $0 != caregiverID })
    }

    private func getFavoritingCaregivers(for item: LibraryItem) -> [String] {
        switch item {
            case let .activity(activity):
                self.getFavoritingCaregiversForActivity(activityID: activity.id)
            case let .curriculum(curriculum):
                self.getFavoritingCaregiversForCurriculum(curriculumID: curriculum.id)
            case let .story(story):
                self.getFavoritingCaregiversForStory(storyID: story.id)
        }
    }

    private func getFavoritingCaregiversForActivity(activityID: String) -> [String] {
        guard let favoritedBy = self.activities.first(where: { $0.id == activityID })?.favoritedBy else { return [] }
        return Array(favoritedBy.keys)
    }

    private func getFavoritingCaregiversForCurriculum(curriculumID: String) -> [String] {
        guard let favoritedBy = self.curriculums.first(where: { $0.id == curriculumID })?.favoritedBy else { return [] }
        return Array(favoritedBy.keys)
    }

    private func getFavoritingCaregiversForStory(storyID: String) -> [String] {
        guard let favoritedBy = self.stories.first(where: { $0.id == storyID })?.favoritedBy else { return [] }
        return Array(favoritedBy.keys)
    }
}
