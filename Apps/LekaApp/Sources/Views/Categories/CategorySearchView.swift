// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI
import UtilsKit

// MARK: - CategorySearchView

struct CategorySearchView: View {
    // MARK: Internal

    var body: some View {
        Group {
            if self.query.isEmpty {
                ScrollView(showsIndicators: false) {
                    SkillsGridView(skills: self.skills)
                }
                .navigationTitle(String(l10n.CategorySearchView.browseSkillstitle.characters))
                .font(.title.bold())
            } else {
                ScrollView(showsIndicators: false) {
                    SearchGridView(
                        skills: self.searchSkillsResults,
                        activities: self.searchActivityResults,
                        curriculums: self.searchCurriculumResults
                    )
                }
            }
        }
        .searchable(text: self.$query)
    }

    var searchActivityResults: [Activity] {
        var scoredActivities: [(activity: Activity, score: Int)] = []
        for activity in self.activities {
            var totalScore = 0

            let titleResult = fuzzyMatch(input: activity.details.title, pattern: self.query)
            totalScore += titleResult.score * self.kTitleWeight

            let subtitleResult = fuzzyMatch(input: activity.details.subtitle ?? "", pattern: self.query)
            totalScore += subtitleResult.score * self.kSubtitleWeight

            for tag in activity.tags {
                let tagResult = fuzzyMatch(input: tag.name, pattern: self.query)
                totalScore += tagResult.score * self.kTagWeight
            }
            scoredActivities.append((activity: activity, score: totalScore))
        }

        var scoredActivitiesFiltered = scoredActivities.filter { $0.score > 0 }.prefix(15)
        scoredActivitiesFiltered.sort { $0.score > $1.score }

        return scoredActivitiesFiltered.map(\.activity)
    }

    var searchSkillsResults: [Skill] {
        var scoredSkill: [(skill: Skill, score: Int)] = []
        for skill in self.skills {
            var totalScore = 0

            let titleResult = fuzzyMatch(input: skill.name, pattern: self.query)
            totalScore += titleResult.score * self.kTitleWeight

            scoredSkill.append((skill: skill, score: totalScore))
        }

        var scoredSkillFiltered = scoredSkill.filter { $0.score > 0 }.prefix(15)
        scoredSkillFiltered.sort { $0.score > $1.score }

        return scoredSkillFiltered.map(\.skill)
    }

    var searchCurriculumResults: [Curriculum] {
        var scoredCurriculum: [(curriculum: Curriculum, score: Int)] = []
        for curriculum in self.curriculums {
            var totalScore = 0

            let titleResult = fuzzyMatch(input: curriculum.details.title, pattern: self.query)
            totalScore += titleResult.score * self.kTitleWeight

            let subtitleResult = fuzzyMatch(input: curriculum.details.subtitle ?? "", pattern: self.query)
            totalScore += subtitleResult.score * self.kSubtitleWeight

            for tag in curriculum.tags {
                let tagResult = fuzzyMatch(input: tag.name, pattern: self.query)
                totalScore += tagResult.score * self.kTagWeight
            }

            scoredCurriculum.append((curriculum: curriculum, score: totalScore))
        }

        var scoredCurriculumFiltered = scoredCurriculum.filter { $0.score > 0 }.prefix(15)
        scoredCurriculumFiltered.sort { $0.score > $1.score }

        return scoredCurriculumFiltered.map(\.curriculum)
    }

    // MARK: Private

    private let kTitleWeight = 10
    private let kSubtitleWeight = 3
    private let kTagWeight = 5

    private let activities: [Activity] = Array(ContentKit.allPublishedActivities.values)
    private let curriculums: [Curriculum] = Array(ContentKit.allPublishedCurriculums.values)
    private let skills: [Skill] = Skills.primarySkillsList

    @State private var query = ""
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
