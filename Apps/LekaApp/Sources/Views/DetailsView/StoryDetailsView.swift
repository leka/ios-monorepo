// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
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
        InfoDetailsView(CurationItemModel(id: self.story.id, name: self.story.name, contentType: .story))
            .toolbar {
                if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                    ToolbarItemGroup {
                        if self.libraryManagerViewModel.isStoryFavoritedByCurrentCaregiver(
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
    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    private let story: Story
}

// MARK: - l10n.StoryDetailsView

extension l10n {
    enum StoryDetailsView {
        static let startStoryButtonLabel = LocalizedString("lekaapp.story_list_view.start_story_button_label",
                                                           value: "Start story",
                                                           comment: "Start Story button label on Sample Story List view")
    }
}

#Preview {
    NavigationStack {
        StoryDetailsView(story: Story.mock)
    }
}
