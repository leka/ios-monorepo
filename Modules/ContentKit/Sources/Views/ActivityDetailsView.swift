// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Fit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - ActivityDetailsView

public struct ActivityDetailsView: View {
    // MARK: Lifecycle

    public init(activity: Activity, onActivitySelected: ((Activity) -> Void)? = nil) {
        self.activity = activity
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        List {
            Section {
                HStack {
                    HStack(alignment: .center) {
                        Image(uiImage: self.activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 8) {
                            Text(self.activity.details.title)
                                .font(.largeTitle)
                                .bold()

                            if let subtitle = self.activity.details.subtitle {
                                Text(subtitle)
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }

                            Text(markdown: self.activity.details.shortDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.ActivityDetailsView.skillsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.activity.skills, id: \.self) { skill in
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
                    })
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.ActivityDetailsView.authorsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.activity.authors, id: \.self) { author in
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
                    })
                }
            }

            Section(String(l10n.ActivityDetailsView.descriptionSectionTitle.characters)) {
                Markdown(self.activity.details.description)
                    .markdownTheme(.gitHub)
            }

            Section(String(l10n.ActivityDetailsView.instructionsSectionTitle.characters)) {
                Markdown(self.activity.details.instructions)
                    .markdownTheme(.gitHub)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    self.onActivitySelected?(self.activity)
                } label: {
                    Image(systemName: "play.circle")
                    Text("Start activity")
                }
                .buttonStyle(.borderedProminent)
                .tint(.lkGreen)
                .disabled(self.onActivitySelected == nil)
                .opacity(self.onActivitySelected == nil ? 0 : 1)
            }
        }
    }

    // MARK: Internal

    var onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    private let activity: Activity

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?
}

// MARK: - l10n.ActivityDetailsView

extension l10n {
    enum ActivityDetailsView {
        static let skillsSectionTitle = LocalizedString("content_kit.activity_details_view.skills_section_title",
                                                        bundle: ContentKitResources.bundle,
                                                        value: "Skills",
                                                        comment: "ActivityDetailsView 'skills' section title")

        static let authorsSectionTitle = LocalizedString("content_kit.activity_details_view.authors_section_title",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Authors",
                                                         comment: "ActivityDetailsView 'authors' section title")

        static let descriptionSectionTitle = LocalizedString("content_kit.activity_details_view.description_section_title",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Description",
                                                             comment: "ActivityDetailsView 'description' section title")

        static let instructionsSectionTitle = LocalizedString("content_kit.activity_details_view.instructions_section_title",
                                                              bundle: ContentKitResources.bundle,
                                                              value: "Instructions",
                                                              comment: "ActivityDetailsView 'instructions' section title")
    }
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}
