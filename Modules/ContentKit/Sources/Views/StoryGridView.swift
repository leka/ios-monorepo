// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
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
                        .onAppear {
                            AnalyticsManager.logEventSelectContent(
                                type: .story,
                                id: story.id,
                                name: story.name,
                                origin: .generalLibrary
                            )
                        }
                ) {
                    VStack(spacing: 0) {
                        Image(uiImage: story.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 155, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * 120))
                            .padding(.bottom)

                        Text(story.details.title)
                            .font(.headline)
                            .foregroundStyle(Color.primary)

                        Text(story.details.subtitle ?? "")
                            .font(.body)
                            .foregroundStyle(Color.secondary)

                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
        }
    }

    // MARK: Internal

    let stories: [Story]
    let onStartStory: ((Story) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    private let columns = Array(repeating: GridItem(), count: 3)
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
