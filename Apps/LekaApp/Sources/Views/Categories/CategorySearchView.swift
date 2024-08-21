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
            let normalizedSearchText = self.searchText.normalized()

            let fuzzyMatches = self.activities.filter { activity in
                if let score = self.fuse.searchSync(normalizedSearchText, in: activity.details.title.normalized())?.score {
                    return score < self.tolerance
                }
                return false
            }

            let tagMatches = self.activities.filter { activity in
                activity.tags.contains { tag in
                    if let score = self.fuse.searchSync(self.searchText.normalized(), in: tag.name.normalized())?.score {
                        return score < self.tolerance
                    }
                    return false
                }
            }

            let combinedResults = Array(Set(fuzzyMatches + tagMatches))

            return combinedResults.sorted { activity1, activity2 in
                let score1 = self.fuse.searchSync(normalizedSearchText, in: activity1.details.title.normalized())?.score ?? 1
                let score2 = self.fuse.searchSync(normalizedSearchText, in: activity2.details.title.normalized())?.score ?? 1
                return score1 < score2
            }
        }
    }

    var searchSkillsResults: [Skill] {
        if self.searchText.isEmpty {
            return self.skills
        } else {
            let normalizedSearchText = self.searchText.normalized()

            let fuzzyMatches = self.skills.filter { skill in
                if let score = self.fuse.searchSync(normalizedSearchText, in: skill.name.normalized())?.score {
                    return score < self.tolerance
                }
                return false
            }

            return fuzzyMatches.sorted { skill1, skill2 in

                let score1 = self.fuse.searchSync(normalizedSearchText, in: skill1.name.normalized())?.score ?? 1
                let score2 = self.fuse.searchSync(normalizedSearchText, in: skill2.name.normalized())?.score ?? 1

                return score1 < score2
            }
        }
    }

    var searchCurriculumResults: [Curriculum] {
        if self.searchText.isEmpty {
            return self.curriculums
        } else {
            let normalizedSearchText = self.searchText.normalized()

            let fuzzyMatches = self.curriculums.filter { curriculum in
                if let score = self.fuse.searchSync(normalizedSearchText, in: curriculum.name.normalized())?.score {
                    return score < self.tolerance
                }
                return false
            }

            let tagMatches = self.curriculums.filter { curriculum in
                curriculum.tags.contains { tag in
                    if let score = self.fuse.searchSync(normalizedSearchText, in: tag.name.normalized())?.score {
                        return score < self.tolerance
                    }
                    return false
                }
            }

            let combinedResults = Array(Set(fuzzyMatches + tagMatches))

            return combinedResults.sorted { curriculum1, curriculum2 in
                let score1 = self.fuse.searchSync(normalizedSearchText, in: curriculum1.name.normalized())?.score ?? 1
                let score2 = self.fuse.searchSync(normalizedSearchText, in: curriculum2.name.normalized())?.score ?? 1
                return score1 < score2
            }
        }
    }

    // MARK: Private

    private let activities: [Activity] = ContentKit.allPublishedActivities
    private let curriculums: [Curriculum] = ContentKit.allPublishedCurriculums
    private let skills: [Skill] = Skills.primarySkillsList
    private let tags: [Tag] = Tags.primaryTagsList
    private let tolerance: Double = 0.6
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
