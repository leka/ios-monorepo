// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - LibraryStoryListView

public struct LibraryStoryListView: View {
    // MARK: Lifecycle

    public init(stories: [Story]? = nil, onStartStory: ((Story) -> Void)?) {
        self.stories = stories ?? []
        self.onStartStory = onStartStory
    }

    // MARK: Public

    public var body: some View {
        Table(self.stories) {
            TableColumn("Title") { story in
                NavigationLink(destination:
                    StoryDetailsView(story: story, onStartStory: self.onStartStory)
                        .logEventScreenView(
                            screenName: "story_details",
                            context: .splitView,
                            parameters: ["lk_story_id": "\(story.name)-\(story.id)"]
                        )
                ) {
                    HStack(spacing: 10) {
                        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
                           self.libraryManagerViewModel.isStoryFavoritedByCurrentCaregiver(
                               storyID: story.id,
                               caregiverID: currentCaregiverID
                           )
                        {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(self.styleManager.accentColor ?? .blue)
                                .frame(width: 10)
                        } else {
                            Color.clear
                                .frame(width: 10)
                        }

                        Image(uiImage: story.details.iconImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 50, height: 50)

                        VStack(alignment: .leading) {
                            Text(story.details.title)
                                .font(.headline)

                            if let subtitle = story.details.subtitle {
                                Text(subtitle)
                                    .font(.subheadline)
                            }
                        }

                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .width(min: 400, ideal: 450, max: .infinity)

            #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                TableColumn("") { story in
                    if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                        Menu {
                            self.addOrRemoveButton(story: story, caregiverID: currentCaregiverID)
                            Divider()
                            self.addOrRemoveFavoriteButton(story: story, caregiverID: currentCaregiverID)
                        } label: {
                            Image(systemName: "ellipsis")
                                .bold()
                        }
                        .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
                    }
                }
                .width(50)
            #endif

            TableColumn("") { story in
                Button {
                    self.onStartStory?(story)
                } label: {
                    Image(systemName: "play.circle")
                        .font(.system(size: 24))
                        .contentShape(Rectangle())
                }
                .tint(.lkGreen)
            }
            .width(50)
        }
        .tableStyle(.inset)
    }

    // MARK: Internal

    let stories: [Story]
    let onStartStory: ((Story) -> Void)?

    // MARK: Private

    @ObservedObject private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManager: LibraryManager = .shared

    @ViewBuilder
    private func addOrRemoveButton(story: Story, caregiverID: String) -> some View {
        let libraryItem = LibraryItem.story(
            SavedStory(id: story.uuid, caregiverID: caregiverID)
        )

        if self.libraryManagerViewModel.isStorySaved(storyID: story.uuid) {
            Button(role: .destructive) {
                self.libraryManagerViewModel.requestItemRemoval(libraryItem, caregiverID: caregiverID)
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
    private func addOrRemoveFavoriteButton(story: Story, caregiverID: String) -> some View {
        if self.libraryManagerViewModel.isStoryFavoritedByCurrentCaregiver(
            storyID: story.uuid,
            caregiverID: caregiverID
        ) {
            Button {
                self.libraryManager.removeStoryFromFavorites(
                    storyID: story.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Undo Favorite", systemImage: "star.slash")
            }
        } else {
            Button {
                self.libraryManager.addStoryToLibraryAsFavorite(
                    storyID: story.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Favorite", systemImage: "star")
            }
        }
    }
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        NavigationStack {
            LibraryStoryListView(
                stories: ContentKit.allStories,
                onStartStory: { _ in
                    print("Story Started")
                }
            )
        }
    }
}
