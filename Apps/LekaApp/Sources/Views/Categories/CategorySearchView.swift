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
        .task(id: self.query) {
            let query = self.query
            guard !query.isEmpty else {
                self.searchActivityResults = []
                self.searchSkillsResults = []
                self.searchCurriculumResults = []
                return
            }

            do {
                try await Task.sleep(for: .milliseconds(300))
            } catch is CancellationError {
                return
            } catch {
                fatalError("Unexpected search debounce failure: \(error)")
            }

            guard !Task.isCancelled else {
                return
            }

            self.searchActivityResults = self.filterActivities(matching: query)
            self.searchSkillsResults = self.filterSkills(matching: query)
            self.searchCurriculumResults = self.filterCurriculums(matching: query)
        }
    }

    func filterActivities(matching query: String) -> [Activity] {
        var scoredActivities: [(activity: Activity, score: Int)] = []
        for activity in self.activities {
            var totalScore = 0

            let titleResult = fuzzyMatch(input: activity.details.title, pattern: query)
            totalScore += titleResult.score * self.kTitleWeight

            let subtitleResult = fuzzyMatch(input: activity.details.subtitle ?? "", pattern: query)
            totalScore += subtitleResult.score * self.kSubtitleWeight

            for tag in activity.tags {
                let tagResult = fuzzyMatch(input: tag.name, pattern: query)
                totalScore += tagResult.score * self.kTagWeight
            }
            scoredActivities.append((activity: activity, score: totalScore))
        }

        var scoredActivitiesFiltered = scoredActivities.filter { $0.score > 0 }.prefix(15)
        scoredActivitiesFiltered.sort { $0.score > $1.score }

        return scoredActivitiesFiltered.map(\.activity)
    }

    func filterSkills(matching query: String) -> [Skill] {
        var scoredSkill: [(skill: Skill, score: Int)] = []
        for skill in self.skills {
            var totalScore = 0

            let titleResult = fuzzyMatch(input: skill.name, pattern: query)
            totalScore += titleResult.score * self.kTitleWeight

            scoredSkill.append((skill: skill, score: totalScore))
        }

        var scoredSkillFiltered = scoredSkill.filter { $0.score > 0 }.prefix(15)
        scoredSkillFiltered.sort { $0.score > $1.score }

        return scoredSkillFiltered.map(\.skill)
    }

    func filterCurriculums(matching query: String) -> [Curriculum] {
        var scoredCurriculum: [(curriculum: Curriculum, score: Int)] = []
        for curriculum in self.curriculums {
            var totalScore = 0

            let titleResult = fuzzyMatch(input: curriculum.details.title, pattern: query)
            totalScore += titleResult.score * self.kTitleWeight

            let subtitleResult = fuzzyMatch(input: curriculum.details.subtitle ?? "", pattern: query)
            totalScore += subtitleResult.score * self.kSubtitleWeight

            for tag in curriculum.tags {
                let tagResult = fuzzyMatch(input: tag.name, pattern: query)
                totalScore += tagResult.score * self.kTagWeight
            }

            scoredCurriculum.append((curriculum: curriculum, score: totalScore))
        }

        var scoredCurriculumFiltered = scoredCurriculum.filter { $0.score > 0 }.prefix(15)
        scoredCurriculumFiltered.sort { $0.score > $1.score }

        return scoredCurriculumFiltered.map(\.curriculum)
    }

    // MARK: Private

    @State private var query = ""
    @State private var searchActivityResults: [Activity] = []
    @State private var searchSkillsResults: [Skill] = []
    @State private var searchCurriculumResults: [Curriculum] = []

    private let kTitleWeight = 10
    private let kSubtitleWeight = 3
    private let kTagWeight = 5

    private let activities: [Activity] = Array(ContentKit.allPublishedNewActivities.values)
    private let curriculums: [Curriculum] = Array(ContentKit.allPublishedCurriculums.values)
    private let skills: [Skill] = Skills.primarySkillsList
}

// MARK: - l10n.CategorySearchView

extension l10n {
    enum CategorySearchView {
        static let browseSkillstitle = LocalizedString(
            "lekaapp.category_search_view.browse_skills_title",
            value: "Browse skills",
            comment: "Browse skills title"
        )
    }
}

#Preview {
    CategorySearchView()
}
