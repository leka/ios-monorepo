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
                        .logEventScreenView(
                            screenName: "story_details",
                            context: .splitView,
                            parameters: [
                                "lk_story_id": "\(story.name)-\(story.id)",
                            ]
                        )
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
                                Button {}
                                    label: {
                                        Menu {
                                            if self.libraryManagerViewModel.isStorySaved(storyID: story.uuid) {
                                                Button(role: .destructive) {
                                                    self.libraryManager.removeStory(storyID: story.uuid)
                                                } label: {
                                                    Label(String(l10n.Library.MenuActions.removeFromlibraryButtonLabel.characters), systemImage: "trash")
                                                }
                                            } else {
                                                Button {
                                                    self.libraryManager.addStory(
                                                        storyID: story.uuid,
                                                        caregiverID: currentCaregiverID
                                                    )
                                                } label: {
                                                    Label(String(l10n.Library.MenuActions.addTolibraryButtonLabel.characters), systemImage: "plus")
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .bold()
                                        }
                                        .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
                                    }
                            }
                        #endif
                        Button {
                            self.onStartStory?(story)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "play.fill")
                                Text(l10n.StoryListView.playButtonLabel)
                                    .font(.callout)
                            }
                            .foregroundColor(.lkGreen)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .overlay(
                                Capsule()
                                    .stroke(Color.lkGreen, lineWidth: 1)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .contentShape(Rectangle())
                    .simultaneousGesture(TapGesture().onEnded {
                        AnalyticsManager.logEventSelectContent(
                            type: .story,
                            id: story.id,
                            name: story.name,
                            origin: .personalLibrary
                        )
                    })
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

    @StateObject private var libraryManagerViewModel = LibraryManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManager: LibraryManager = .shared
}

// MARK: - l10n.StoryListView

extension l10n {
    enum StoryListView {
        static let playButtonLabel = LocalizedString("content_kit.story_list_view.play_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Play",
                                                     comment: "Play button label on Story List view")
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
