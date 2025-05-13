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

    public init(activities: [Activity]? = nil,
                skills: [Skill]? = nil,
                curriculums: [Curriculum]? = nil,
                onStartActivity: ((Activity) -> Void)?)
    {
        self.activities = activities ?? []
        self.skills = skills ?? []
        self.curriculums = curriculums ?? []
        self.onStartActivity = onStartActivity
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
                            ActivityGridView(activities: self.activities, onStartActivity: self.onStartActivity)
                                .navigationTitle(String(l10n.SearchGridView.activitiesTitle.characters))
                        }
                    ) {
                        Text(l10n.SearchGridView.seeAllLabel)
                    }
                }
                .padding(.horizontal)

                ActivityHorizontalListView(activities: self.activities, onStartActivity: self.onStartActivity)
            }

            if !self.curriculums.isEmpty {
                HStack {
                    Text(l10n.SearchGridView.curriculumsTitle)
                        .font(.title.bold())
                    Spacer()
                    NavigationLink(destination:
                        ScrollView(showsIndicators: true) {
                            CurriculumGridView(curriculums: self.curriculums, onStartActivity: self.onStartActivity)
                                .navigationTitle(String(l10n.SearchGridView.curriculumsTitle.characters))
                        }
                    ) {
                        Text(l10n.SearchGridView.seeAllLabel)
                    }
                }
                .padding(.horizontal)

                CurriculumHorizontalListView(curriculums: self.curriculums, onStartActivity: self.onStartActivity)
            }

            if !self.skills.isEmpty {
                HStack {
                    Text(l10n.SearchGridView.skillsTitle)
                        .font(.title.bold())
                    Spacer()
                }
                .padding(.horizontal)

                SkillsGridView(skills: self.skills, onActivitySelected: self.onStartActivity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Internal

    let activities: [Activity]
    let skills: [Skill]
    let curriculums: [Curriculum]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
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
            activities: Array(ContentKit.allActivities.values),
            skills: Skills.primarySkillsList,
            curriculums: Array(ContentKit.allCurriculums.values),
            onStartActivity: { _ in
                print("Activity Started")
            }
        )
    }
}
