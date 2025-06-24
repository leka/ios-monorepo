// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - StoryDetailsView

public struct StoryDetailsView: View {
    // MARK: Lifecycle

    public init(story: Story, onStartStory: ((Story) -> Void)? = nil) {
        self.story = story
        self.onStartStory = onStartStory
    }

    // MARK: Public

    public var body: some View {
        List {
            InfoDetailsView(CurationItemModel(id: self.story.id, name: self.story.name, contentType: .story))

            Section(String(l10n.StoryDetailsView.instructionsSectionTitle.characters)) {
                Markdown(self.story.details.instructions)
            }
        }
        .toolbar {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ToolbarItemGroup {
                    if self.sharedLibraryManagerViewModel.isStoryFavoritedByCurrentCaregiver(
                        storyID: self.story.uuid,
                        caregiverID: currentCaregiverID
                    ) {
                        Image(systemName: "star.circle")
                            .font(.system(size: 21))
                            .foregroundColor(self.styleManager.accentColor ?? .blue)
                    }

                    ContentItemMenu(
                        CurationItemModel(id: self.story.uuid, name: self.story.name, contentType: .story),
                        caregiverID: currentCaregiverID
                    )
                }
            }

            ToolbarItem {
                Button {
                    self.onStartStory?(self.story)
                } label: {
                    Image(systemName: "play.fill")
                    Text(l10n.StoryDetailsView.startStoryButtonLabel)
                }
                .buttonStyle(.borderedProminent)
                .tint(.lkGreen)
                .disabled(self.onStartStory == nil)
                .opacity(self.onStartStory == nil ? 0 : 1)
            }
        }
    }

    // MARK: Internal

    var onStartStory: ((Story) -> Void)?

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared
    private let story: Story
}

// MARK: - l10n.StoryDetailsView

extension l10n {
    enum StoryDetailsView {
        static let startStoryButtonLabel = LocalizedString("lekaapp.story_details_view.start_story_button_label",
                                                           value: "Start story",
                                                           comment: "Start Story button label on Sample Story List view")

        static let instructionsSectionTitle = LocalizedString("lekaapp.story_details_view.instructions_section_title",
                                                              value: "Instructions",
                                                              comment: "StoryDetailsView 'instructions' section title")
    }
}

#Preview {
    NavigationStack {
        StoryDetailsView(story: Story.mock)
    }
}
