// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
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
            TableColumn(String(l10n.Library.titleColumnLabel.characters)) { story in
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
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.logEventSelectContent(
                        type: .story,
                        id: story.id,
                        name: story.name,
                        origin: Navigation.shared.selectedCategory?.rawValue
                    )
                })
            }
            .width(min: 400, ideal: 450, max: .infinity)

            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                TableColumn("") { story in
                    ContentItemMenu(
                        CurationItemModel(id: story.id, name: story.name, contentType: .story),
                        caregiverID: currentCaregiverID
                    )
                }
                .width(50)
            }

            TableColumn("") { story in
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
            .width(80)
        }
        .tableStyle(.inset)
    }

    // MARK: Internal

    let stories: [Story]
    let onStartStory: ((Story) -> Void)?

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
}

// MARK: - l10n.StoryListView

extension l10n {
    enum StoryListView {
        static let playButtonLabel = LocalizedString("lekaapp.story_list_view.play_button_label",
                                                     value: "Play",
                                                     comment: "Play button label on Story List view")
    }
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        NavigationStack {
            LibraryStoryListView(
                stories: Array(ContentKit.allStories.values),
                onStartStory: { _ in
                    print("Story Started")
                }
            )
        }
    }
}
