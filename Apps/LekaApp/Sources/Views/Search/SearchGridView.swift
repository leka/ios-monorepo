// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SearchGridView

public struct SearchGridView: View {
    // MARK: Lifecycle

    public init(skills: [Skill]? = nil,
                activities: [Activity]? = nil,
                curriculums: [Curriculum]? = nil)
    {
        self.skills = skills ?? []
        self.activities = activities?.map { CurationItemModel(id: $0.id, name: $0.name, contentType: .activity) } ?? []
        self.curriculums = curriculums?.map { CurationItemModel(id: $0.id, name: $0.name, contentType: .curriculum) } ?? []
    }

    // MARK: Public

    public var body: some View {
        VStack {
            if self.activities.isEmpty, self.curriculums.isEmpty, self.skills.isEmpty {
                Text(l10n.SearchGridView.noResults)
                    .font(.title)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            if !self.activities.isEmpty {
                HStack {
                    Text(l10n.SearchGridView.activitiesTitle)
                        .font(.title.bold())
                    Spacer()
                    NavigationLink(destination:
                        ScrollView(showsIndicators: true) {
                            VerticalActivityGrid(items: self.activities)
                                .navigationTitle(String(l10n.SearchGridView.activitiesTitle.characters))
                        }
                    ) {
                        Text(l10n.SearchGridView.seeAllLabel)
                    }
                }
                .padding(.horizontal)

                HorizontalActivityList(items: self.activities)
            }

            if !self.curriculums.isEmpty {
                HStack {
                    Text(l10n.SearchGridView.curriculumsTitle)
                        .font(.title.bold())
                    Spacer()
                    NavigationLink(destination:
                        ScrollView(showsIndicators: true) {
                            VerticalCurriculumGrid(items: self.curriculums)
                                .navigationTitle(String(l10n.SearchGridView.curriculumsTitle.characters))
                        }
                    ) {
                        Text(l10n.SearchGridView.seeAllLabel)
                    }
                }
                .padding(.horizontal)

                HorizontalCurriculumList(items: self.curriculums)
            }

            if !self.skills.isEmpty {
                HStack {
                    Text(l10n.SearchGridView.skillsTitle)
                        .font(.title.bold())
                    Spacer()
                }
                .padding(.horizontal)

                SkillsGridView(skills: self.skills)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Internal

    let skills: [Skill]
    let activities: [CurationItemModel]
    let curriculums: [CurationItemModel]
}

// MARK: - l10n.SearchGridView

extension l10n {
    enum SearchGridView {
        static let activitiesTitle = LocalizedString("lekaapp.search_grid_view.activities_title",
                                                     value: "Activities",
                                                     comment: "SearchGridView 'activities' section title")

        static let curriculumsTitle = LocalizedString("lekaapp.search_grid_view.curriculums_title",
                                                      value: "Curriculums",
                                                      comment: "SearchGridView 'curriculums' section title")

        static let skillsTitle = LocalizedString("lekaapp.search_grid_view.skills_title",
                                                 value: "Skills",
                                                 comment: "SearchGridView 'skills' section title")

        static let seeAllLabel = LocalizedString("lekaapp.search_grid_view.see_all_label",
                                                 value: "See all",
                                                 comment: "SearchGridView 'see all' button label")

        static let noResults = LocalizedString("lekaapp.search_grid_view.no_results",
                                               value: "Oops! No results found.",
                                               comment: "SearchGridView 'see all' button label")
    }
}

#Preview {
    NavigationStack {
        SearchGridView(
            skills: Skills.primarySkillsList,
            activities: Array(ContentKit.allActivities.values),
            curriculums: Array(ContentKit.allCurriculums.values)
        )
    }
}
