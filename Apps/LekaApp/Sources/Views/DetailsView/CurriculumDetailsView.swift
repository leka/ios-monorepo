// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import Fit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - CurriculumDetailsView

public struct CurriculumDetailsView: View {
    // MARK: Lifecycle

    public init(curriculum: Curriculum, onStartActivity: ((Activity) -> Void)? = nil) {
        self.curriculum = curriculum
        self.onStartActivity = onStartActivity
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
                            .frame(width: self.kIconSize, height: self.kIconSize)
                            .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize))

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .center) {
                                Text(self.curriculum.details.title)
                                    .font(.largeTitle)
                                    .bold()

                                Spacer()

                                VStack {
                                    Image(systemName: "graduationcap")
                                        .font(.title3)
                                    Text(l10n.CurriculumDetailsView.curriculumLabel)
                                        .font(.caption)
                                }

                                VStack {
                                    Text(self.curriculum.activities.count.description)
                                        .font(.title3)
                                    Text(l10n.CurriculumDetailsView.activitiesSectionTitle)
                                        .font(.caption)
                                }
                            }

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

                VStack {
                    if self.isDescriptionExpanded {
                        Markdown(self.curriculum.details.description)
                            .markdownTheme(.gitHub)
                    }

                    HStack {
                        Spacer()

                        Button(self.isDescriptionExpanded ?
                            String(l10n.CurriculumDetailsView.seeLessLabel.characters) :
                            String(l10n.CurriculumDetailsView.seeMoreLabel.characters))
                        {
                            self.isDescriptionExpanded.toggle()
                        }
                        .foregroundColor(self.styleManager.accentColor!)
                    }
                }
            }

            Section(String(l10n.CurriculumDetailsView.activitiesSectionTitle.characters)) {
                ScrollView(showsIndicators: true) {
                    ActivityListView(
                        activities: self.curriculum.activities.compactMap { Activity(id: $0) },
                        onStartActivity: self.onStartActivity
                    )
                }
            }
        }
        .toolbar {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ToolbarItemGroup {
                    if self.libraryManagerViewModel.isCurriculumFavoritedByCurrentCaregiver(
                        curriculumID: self.curriculum.uuid,
                        caregiverID: currentCaregiverID
                    ) {
                        Image(systemName: "star.circle")
                            .font(.system(size: 21))
                            .foregroundColor(self.styleManager.accentColor ?? .blue)
                    }

                    ContentItemMenu(
                        CurationItemModel(id: self.curriculum.uuid, contentType: .curriculum),
                        caregiverID: currentCaregiverID
                    )
                }
            }
        }
    }

    // MARK: Internal

    var onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?
    @State private var isDescriptionExpanded = false

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    private let curriculum: Curriculum

    private let kIconSize: CGFloat = 150
}

// MARK: - l10n.CurriculumDetailsView

extension l10n {
    enum CurriculumDetailsView {
        static let curriculumLabel = LocalizedString("lekaapp.curriculum_details_view.curriculum_label",
                                                     value: "Curriculum",
                                                     comment: "CurriculumDetailsView's content type description label")

        static let seeMoreLabel = LocalizedString("lekaapp.curriculum_details_view.see_more_label",
                                                  value: "See more",
                                                  comment: "See more button label")

        static let seeLessLabel = LocalizedString("lekaapp.curriculum_details_view.see_less_label",
                                                  value: "See less",
                                                  comment: "See less button label")

        static let skillsSectionTitle = LocalizedString("lekaapp.curriculum_details_view.skills_section_title",
                                                        value: "Skills",
                                                        comment: "CurriculumDetailsView 'skills' section title")

        static let authorsSectionTitle = LocalizedString("lekaapp.curriculum_details_view.authors_section_title",
                                                         value: "Authors",
                                                         comment: "CurriculumDetailsView 'authors' section title")

        static let descriptionSectionTitle = LocalizedString("lekaapp.curriculum_details_view.description_section_title",
                                                             value: "Description",
                                                             comment: "CurriculumDetailsView 'description' section title")

        static let activitiesSectionTitle = LocalizedString("lekaapp.curriculum_details_view.activities_section_title",
                                                            value: "Activities",
                                                            comment: "CurriculumDetailsView 'activities' section title")
    }
}

#Preview {
    NavigationStack {
        CurriculumDetailsView(curriculum: Curriculum.mock)
    }
}
