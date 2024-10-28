// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - StoryListView

public struct StoryListView: View {
    // MARK: Lifecycle

    public init(stories: [Story]? = nil, onStartStory: ((Story) -> Void)?) {
        self.stories = stories ?? []
        self.onStartStory = onStartStory
    }

    // MARK: Public

    public var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(self.stories) { story in
                NavigationLink(destination:
                    StoryDetailsView(story: story, onStartStory: self.onStartStory)
                ) {
                    HStack(alignment: .center, spacing: 30) {
                        Image(uiImage: story.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 50)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            HStack {
                                Text(story.details.title)
                                    .font(.headline)
                                    .frame(alignment: .leading)
                            }

                            if let subtitle = story.details.subtitle {
                                Text(subtitle)
                                    .font(.subheadline)
                                    .frame(alignment: .leading)
                            }
                        }
                        .padding(.vertical)

                        Spacer()

                        #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                                Menu {
                                    if self.rootAccountViewModel.isStorySaved(storyID: story.uuid) {
                                        Button(role: .destructive) {
                                            self.rootAccountViewModel.removeSavedStory(storyID: story.uuid)
                                        } label: {
                                            Label("Delete from Library", systemImage: "trash")
                                        }
                                    } else {
                                        Button {
                                            self.rootAccountViewModel.addSavedStory(
                                                storyID: story.uuid,
                                                caregiverID: currentCaregiverID
                                            )
                                        } label: {
                                            Label("Add to Library", systemImage: "plus")
                                        }
                                    }
                                } label: {
                                    Button {
                                        // Nothing to do
                                    } label: {
                                        Image(systemName: "ellipsis")
                                    }
                                    .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
                                }
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
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }

    // MARK: Internal

    let stories: [Story]
    let onStartStory: ((Story) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
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
