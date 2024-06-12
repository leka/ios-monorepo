// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CategorySearchView

struct CategorySearchView: View {
    // MARK: Internal

    var body: some View {
        Group {
            if self.searchText.isEmpty {
                ScrollView(showsIndicators: true) {
                    SkillsGridView(skills: self.skills, onActivitySelected: { activity in
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                    })
                }
                .navigationTitle(String(l10n.CategorySearchView.browseSkillstitle.characters))
                .font(.title.bold())
            } else {
                ScrollView(showsIndicators: true) {
                    SearchGridView(activities: self.searchActivityResults,
                                   skills: self.searchSkillsResults,
                                   curriculums: self.searchCurriculumResults,
                                   onStartActivity: { activity in
                                       self.navigation.currentActivity = activity
                                       self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                                   })
                }
            }
        }
        .searchable(text: self.$searchText)
    }

    var searchActivityResults: [Activity] {
        if self.searchText.isEmpty {
            self.activities
        } else {
            self.activities.filter { activity in
                activity.details.title.normalized().contains(self.searchText.normalized())
            }
        }
    }

    var searchSkillsResults: [Skill] {
        if self.searchText.isEmpty {
            self.skills
        } else {
            self.skills.filter { skill in
                skill.name.normalized().contains(self.searchText.normalized())
            }
        }
    }

    var searchCurriculumResults: [Curriculum] {
        if self.searchText.isEmpty {
            self.curriculums
        } else {
            self.curriculums.filter { curriculum in
                curriculum.name.normalized().contains(self.searchText.normalized())
            }
        }
    }

    // MARK: Private

    private let activities: [Activity] = ContentKit.allPublishedActivities
    private let curriculums: [Curriculum] = ContentKit.allCurriculums
    private let skills: [Skill] = Skills.primarySkillsList

    @State private var searchText = ""
    @ObservedObject private var navigation: Navigation = .shared
}

// MARK: - l10n.CategorySearchView

extension l10n {
    enum CategorySearchView {
        static let browseSkillstitle = LocalizedString("lekaapp.category_search_view.browse_skills_title",
                                                       value: "Browse skills",
                                                       comment: "Browse skills title")
    }
}

#Preview {
    CategorySearchView()
}
