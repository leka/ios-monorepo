// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit

public class CurrentStoryManager {
    // MARK: Lifecycle

    public init(story: Story) {
        self.story = story
    }

    // MARK: Public

    public let story: Story
    public var currentPageIndex: Int = 0

    public var totalPages: Int {
        self.story.pages.count
    }

    public var currentPage: Page {
        self.story.pages[self.currentPageIndex]
    }

    public var isFirstPage: Bool {
        self.currentPageIndex == 0
    }

    public var isLastPage: Bool {
        self.currentPageIndex == self.story.pages.count - 1
    }

    public func moveToNextPage() {
        if self.currentPageIndex < self.story.pages.count - 1 {
            self.currentPageIndex += 1
        }
    }

    public func moveToPreviousPage() {
        if self.currentPageIndex > 0 {
            self.currentPageIndex -= 1
        }
    }
}
