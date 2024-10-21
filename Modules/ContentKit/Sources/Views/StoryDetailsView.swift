// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import Fit
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
            Section {
                HStack {
                    HStack(alignment: .center) {
                        Image(uiImage: self.story.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 155, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * 120))

                        VStack(alignment: .leading, spacing: 8) {
                            Text(self.story.details.title)
                                .font(.largeTitle)
                                .bold()

                            if let subtitle = self.story.details.subtitle {
                                Text(subtitle)
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }

                            Text(markdown: self.story.details.shortDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.StoryDetailsView.skillsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.story.skills, id: \.self) { skill in
                            let skill = Skills.skill(id: skill)!

                            TagView(title: skill.name, systemImage: "info.circle") {
                                self.selectedSkill = skill
                            }
                        }
                    }
                    .sheet(item: self.$selectedSkill, onDismiss: { self.selectedSkill = nil }, content: { skill in
                        VStack(alignment: .leading) {
                            Text(skill.name)
                                .font(.headline)
                            Text(skill.description)
                        }
                        .padding()
                    })
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.StoryDetailsView.authorsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.story.authors, id: \.self) { author in
                            let author = Authors.hmi(id: author)!

                            TagView(title: author.name, systemImage: "info.circle") {
                                self.selectedAuthor = author
                            }
                        }
                    }
                    .sheet(item: self.$selectedAuthor, onDismiss: { self.selectedAuthor = nil }, content: { author in
                        VStack(alignment: .leading) {
                            Text(author.name)
                                .font(.headline)
                            Text(author.description)
                        }
                        .padding()
                    })
                }
            }

            Section(String(l10n.StoryDetailsView.descriptionSectionTitle.characters)) {
                Markdown(self.story.details.description)
                    .markdownTheme(.gitHub)
            }

            Section(String(l10n.StoryDetailsView.instructionsSectionTitle.characters)) {
                Markdown(self.story.details.instructions)
                    .markdownTheme(.gitHub)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    let currentCaregiverID: String = self.caregiverManagerViewModel.currentCaregiver?.id ?? ""
                    if self.rootAccountViewModel.isStorySaved(storyID: self.story.uuid) {
                        self.rootAccountViewModel.removeSavedStory(storyID: self.story.uuid)
                    } else {
                        self.rootAccountViewModel.addSavedStory(
                            storyID: self.story.uuid,
                            caregiverID: currentCaregiverID
                        )
                    }
                } label: {
                    if self.rootAccountViewModel.isStorySaved(storyID: self.story.uuid) {
                        Image(systemName: "trash")
                    } else {
                        Image(systemName: "plus")
                    }
                }
                .tint(self.rootAccountViewModel.isStorySaved(storyID: self.story.uuid) ? .red : self.styleManager.accentColor!)
            }
            ToolbarItem {
                Button {
                    self.onStartStory?(self.story)
                } label: {
                    Image(systemName: "play.circle")
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

    private let story: Story

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
}

// MARK: - l10n.StoryDetailsView

extension l10n {
    enum StoryDetailsView {
        static let skillsSectionTitle = LocalizedString("content_kit.story_details_view.skills_section_title",
                                                        bundle: ContentKitResources.bundle,
                                                        value: "Skills",
                                                        comment: "StoryDetailsView 'skills' section title")

        static let authorsSectionTitle = LocalizedString("content_kit.story_details_view.authors_section_title",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Authors",
                                                         comment: "StoryDetailsView 'authors' section title")

        static let descriptionSectionTitle = LocalizedString("content_kit.story_details_view.description_section_title",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Description",
                                                             comment: "StoryDetailsView 'description' section title")

        static let instructionsSectionTitle = LocalizedString("content_kit.story_details_view.instructions_section_title",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "Instructions",
                                                              comment: "StoryDetailsView 'instructions' section title")

        static let startStoryButtonLabel = LocalizedString("content_kit.sample_story_list_view.start_story_button_label",
                                                           bundle: ContentKitResources.bundle,
                                                           value: "Start story",
                                                           comment: "Start Story button label on Sample Story List view")
    }
}

#Preview {
    NavigationStack {
        StoryDetailsView(story: Story.mock)
    }
}
