// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

class StoryViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(story: Story) {
        self.currentStory = story

        self.storyManager = CurrentStoryManager(story: story)

        self.totalPages = self.storyManager.totalPages
        self.currentPageIndex = self.storyManager.currentPageIndex

        self.currentPage = self.storyManager.currentPage
    }

    // MARK: Internal

    @Published var currentStory: Story

    @Published var totalPages: Int
    @Published var currentPageIndex: Int
    @Published var currentPage: Page

    @Published var isCurrentstoryCompleted: Bool = false

    var isFirstPage: Bool {
        self.storyManager.isFirstPage
    }

    var isLastPage: Bool {
        self.storyManager.isLastPage
    }

    func moveToNextPage() {
        self.storyManager.moveToNextPage()
        self.updateValues()
    }

    func moveToPreviousPage() {
        self.storyManager.moveToPreviousPage()
        self.updateValues()
    }

    func moveToStoryEnd() {
        self.isCurrentstoryCompleted = true
    }

    // MARK: Private

    private let storyManager: CurrentStoryManager

    private func updateValues() {
        self.currentPage = self.storyManager.currentPage
        self.totalPages = self.storyManager.totalPages
        self.currentPageIndex = self.storyManager.currentPageIndex
    }
}
