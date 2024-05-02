// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - StoryGridView

public struct StoryGridView: View {
    // MARK: Lifecycle

    public init(stories: [Story]? = nil, onStartStory: ((Story) -> Void)?) {
        self.stories = stories ?? []
        self.onStartStory = onStartStory
    }

    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns) {
            ForEach(self.stories) { story in
                NavigationLink(destination:
                    StoryDetailsView(story: story, onStartStory: self.onStartStory)
                ) {
                    VStack(spacing: 0) {
                        Image(uiImage: story.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250)

                        Text(story.details.title)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                            .padding(.top, -30)

                        Text(story.details.subtitle ?? "")
                            .font(.body)
                            .foregroundStyle(Color.secondary)

                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: Internal

    let stories: [Story]
    let onStartStory: ((Story) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    NavigationStack {
        StoryGridView(
            stories: ContentKit.allStories,
            onStartStory: { _ in
                print("Story Started")
            }
        )
    }
}
