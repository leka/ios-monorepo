// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import Ifrit
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
            return self.activities
        } else {
            let bestResultSorted = self.activities.sorted { activity1, activity2 in
                self.fuse.search(self.searchText.normalized(), in: activity1.details.title.normalized())?.score ?? 1 <
                    self.fuse.search(self.searchText.normalized(), in: activity2.details.title.normalized())?.score ?? 1
            }
            return bestResultSorted.filter { activity in
                self.fuse.search(self.searchText.normalized(), in: activity.details.title.normalized())?.score ?? 1 < 0.3
            }
        }
    }

    var searchSkillsResults: [Skill] {
        if self.searchText.isEmpty {
            return self.skills
        } else {
            let bestResultSorted = self.skills.sorted { skill1, skill2 in
                self.fuse.search(self.searchText.normalized(), in: skill1.name.normalized())?.score ?? 1 <
                    self.fuse.search(self.searchText.normalized(), in: skill2.name.normalized())?.score ?? 1
            }
            return bestResultSorted.filter { skill in
                self.fuse.search(self.searchText.normalized(), in: skill.name.normalized())?.score ?? 1 < 0.3
            }
        }
    }

    var searchCurriculumResults: [Curriculum] {
        if self.searchText.isEmpty {
            return self.curriculums
        } else {
            let bestResultSorted = self.curriculums.sorted { curriculum1, curriculum2 in
                self.fuse.search(self.searchText.normalized(), in: curriculum1.name.normalized())?.score ?? 1 <
                    self.fuse.search(self.searchText.normalized(), in: curriculum2.name.normalized())?.score ?? 1
            }
            return bestResultSorted.filter { curriculum in
                self.fuse.search(self.searchText.normalized(), in: curriculum.name.normalized())?.score ?? 1 < 0.3
            }
        }
    }

    // MARK: Private

    private let activities: [Activity] = ContentKit.allPublishedActivities
    private let curriculums: [Curriculum] = ContentKit.allCurriculums
    private let skills: [Skill] = Skills.primarySkillsList
    private let fuse = Fuse()

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
