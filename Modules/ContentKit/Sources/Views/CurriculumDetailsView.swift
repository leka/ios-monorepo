// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Fit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - CurriculumDetailsView

public struct CurriculumDetailsView: View {
    // MARK: Lifecycle

    public init(curriculum: Curriculum, onActivitySelected: ((Activity) -> Void)? = nil) {
        self.curriculum = curriculum
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        List {
            Section {
                HStack {
                    HStack(alignment: .center) {
                        Image(uiImage: self.curriculum.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 8) {
                            Text(self.curriculum.details.title)
                                .font(.largeTitle)
                                .bold()

                            if let subtitle = self.curriculum.details.subtitle {
                                Text(subtitle)
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }

                            Text(markdown: self.curriculum.details.abstract)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.CurriculumDetailsView.skillsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.curriculum.skills, id: \.self) { skill in
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
                    Text(l10n.CurriculumDetailsView.authorsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.curriculum.authors, id: \.self) { author in
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

            Section(String(l10n.CurriculumDetailsView.descriptionSectionTitle.characters)) {
                Markdown(self.curriculum.details.description)
                    .markdownTheme(.gitHub)
            }

            Section(String(l10n.CurriculumDetailsView.activitiesSectionTitle.characters)) {
                ScrollView(showsIndicators: true) {
                    ActivityListView(
                        activities: self.curriculum.activities.compactMap { Activity(id: $0) },
                        onStartActivity: self.onActivitySelected
                    )
                }
            }
        }
    }

    // MARK: Internal

    var onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    private let curriculum: Curriculum

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?
}

// MARK: - l10n.CurriculumDetailsView

extension l10n {
    enum CurriculumDetailsView {
        static let skillsSectionTitle = LocalizedString("content_kit.curriculum_details_view.skills_section_title",
                                                        bundle: ContentKitResources.bundle,
                                                        value: "Skills",
                                                        comment: "CurriculumDetailsView 'skills' section title")

        static let authorsSectionTitle = LocalizedString("content_kit.curriculum_details_view.authors_section_title",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Authors",
                                                         comment: "CurriculumDetailsView 'authors' section title")

        static let descriptionSectionTitle = LocalizedString("content_kit.curriculum_details_view.description_section_title",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Description",
                                                             comment: "CurriculumDetailsView 'description' section title")

        static let activitiesSectionTitle = LocalizedString("content_kit.curriculum_details_view.activities_section_title",
                                                            bundle: ContentKitResources.bundle,
                                                            value: "Activities",
                                                            comment: "CurriculumDetailsView 'activities' section title")
    }
}

#Preview {
    NavigationStack {
        CurriculumDetailsView(curriculum: Curriculum.mock)
    }
}
