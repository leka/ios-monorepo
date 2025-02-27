// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - StoryListView

public struct StoryListView: View {
    // MARK: Lifecycle

    public init(stories: [Story]? = nil, onStartStory: ((Story) -> Void)? = nil) {
        self.stories = stories ?? []
        self.onStartStory = onStartStory
    }

    // MARK: Public

    public var body: some View {
        ScrollView {
            Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 20) {
                ForEach(self.stories) { story in
                    GridRow {
                        NavigationLink(destination:
                            StoryDetailsView(story: story, onStartStory: self.onStartStory)
                                .logEventScreenView(
                                    screenName: "story_details",
                                    context: .splitView,
                                    parameters: ["lk_story_id": "\(story.name)-\(story.id)"]
                                )
                        ) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(
                                    self.libraryManagerViewModel.isStoryFavorite(storyID: story.uuid) ? (self.styleManager.accentColor ?? .blue) : .clear
                                )
                                .frame(width: 12)

                            HStack(spacing: 10) {
                                Image(uiImage: story.details.iconImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading) {
                                    Text(story.details.title)
                                        .font(.headline)

                                    if let subtitle = story.details.subtitle {
                                        Text(subtitle)
                                            .font(.subheadline)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, maxHeight: 120)
                        .simultaneousGesture(TapGesture().onEnded {
                            AnalyticsManager.logEventSelectContent(
                                type: .story,
                                id: story.id,
                                name: story.name,
                                origin: .personalLibrary
                            )
                        })

                        #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                                Menu {
                                    self.addOrRemoveButton(story: story, caregiverID: currentCaregiverID)
                                    self.addOrRemoveFavoriteButton(story: story, caregiverID: currentCaregiverID)
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .bold()
                                }
                                .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
                                .frame(width: 34)
                            }
                        #endif

                        Button {
                            self.onStartStory?(story)
                        } label: {
                            Image(systemName: "play.circle")
                                .font(.system(size: 24))
                                .contentShape(Rectangle())
                        }
                        .tint(.lkGreen)
                        .frame(width: 34)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: Internal

    let stories: [Story]
    let onStartStory: ((Story) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @StateObject private var libraryManagerViewModel = LibraryManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManager: LibraryManager = .shared

    @ViewBuilder
    private func addOrRemoveButton(story: Story, caregiverID: String) -> some View {
        if self.libraryManagerViewModel.isStorySaved(storyID: story.uuid) {
            Button(role: .destructive) {
                self.libraryManager.removeStory(storyID: story.uuid)
            } label: {
                Label("Remove from Library", systemImage: "trash")
            }
        } else {
            Button {
                self.libraryManager.addStory(
                    storyID: story.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Add to Library", systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    private func addOrRemoveFavoriteButton(story: Story, caregiverID _: String) -> some View {
        if self.libraryManagerViewModel.isStoryFavorite(storyID: story.uuid) {
            Button(role: .destructive) {
                self.libraryManager.toggleStoryFavoriteStatus(storyID: story.uuid)
            } label: {
                Label("Remove from Favorites", systemImage: "star.slash")
            }
        } else {
            Button {
                self.libraryManager.toggleStoryFavoriteStatus(storyID: story.uuid)
            } label: {
                Label("Add to Favorites", systemImage: "star")
            }
        }
    }
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        NavigationStack {
            ScrollView {
                StoryListView(
                    stories: ContentKit.allStories,
                    onStartStory: { _ in
                        print("Story Started")
                    }
                )
            }
        }
    }
}
