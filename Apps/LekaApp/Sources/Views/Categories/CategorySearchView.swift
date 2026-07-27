// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

@preconcurrency import ContentKit
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
                    if self.isSearching {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top)
                    } else {
                        SearchGridView(
                            skills: self.searchSkillsResults,
                            activities: self.searchActivityResults,
                            curriculums: self.searchCurriculumResults
                        )
                    }
                }
            }
        }
        .searchable(text: self.$query)
        .task(id: self.query) {
            let query = self.query
            guard !query.isEmpty else {
                self.isSearching = false
                self.searchActivityResults = []
                self.searchSkillsResults = []
                self.searchCurriculumResults = []
                return
            }

            self.isSearching = true

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

            let activities = self.activities
            let skills = self.skills
            let curriculums = self.curriculums
            let filteringTask = Task.detached(priority: .utility) {
                (
                    activities: Self.filterActivities(activities, matching: query),
                    skills: Self.filterSkills(skills, matching: query),
                    curriculums: Self.filterCurriculums(curriculums, matching: query)
                )
            }
            let results = await withTaskCancellationHandler {
                await filteringTask.value
            } onCancel: {
                filteringTask.cancel()
            }

            guard !Task.isCancelled else {
                return
            }

            self.searchActivityResults = results.activities
            self.searchSkillsResults = results.skills
            self.searchCurriculumResults = results.curriculums
            self.isSearching = false
        }
    }

    nonisolated static func filterActivities(_ activities: [Activity], matching query: String) -> [Activity] {
        var scoredActivities: [(activity: Activity, score: Int)] = []
        for activity in activities {
            guard !Task.isCancelled else {
                return []
            }

            var totalScore = 0

            let titleResult = fuzzyMatch(input: activity.details.title, pattern: query)
            totalScore += titleResult.score * Self.kTitleWeight

            let subtitleResult = fuzzyMatch(input: activity.details.subtitle ?? "", pattern: query)
            totalScore += subtitleResult.score * Self.kSubtitleWeight

            for tag in activity.tags {
                let tagResult = fuzzyMatch(input: tag.name, pattern: query)
                totalScore += tagResult.score * Self.kTagWeight
            }
            scoredActivities.append((activity: activity, score: totalScore))
        }

        var scoredActivitiesFiltered = scoredActivities.filter { $0.score > 0 }.prefix(15)
        scoredActivitiesFiltered.sort { $0.score > $1.score }

        return scoredActivitiesFiltered.map(\.activity)
    }

    nonisolated static func filterSkills(_ skills: [Skill], matching query: String) -> [Skill] {
        var scoredSkill: [(skill: Skill, score: Int)] = []
        for skill in skills {
            guard !Task.isCancelled else {
                return []
            }

            var totalScore = 0

            let titleResult = fuzzyMatch(input: skill.name, pattern: query)
            totalScore += titleResult.score * Self.kTitleWeight

            scoredSkill.append((skill: skill, score: totalScore))
        }

        var scoredSkillFiltered = scoredSkill.filter { $0.score > 0 }.prefix(15)
        scoredSkillFiltered.sort { $0.score > $1.score }

        return scoredSkillFiltered.map(\.skill)
    }

    nonisolated static func filterCurriculums(_ curriculums: [Curriculum], matching query: String) -> [Curriculum] {
        var scoredCurriculum: [(curriculum: Curriculum, score: Int)] = []
        for curriculum in curriculums {
            guard !Task.isCancelled else {
                return []
            }

            var totalScore = 0

            let titleResult = fuzzyMatch(input: curriculum.details.title, pattern: query)
            totalScore += titleResult.score * Self.kTitleWeight

            let subtitleResult = fuzzyMatch(input: curriculum.details.subtitle ?? "", pattern: query)
            totalScore += subtitleResult.score * Self.kSubtitleWeight

            for tag in curriculum.tags {
                let tagResult = fuzzyMatch(input: tag.name, pattern: query)
                totalScore += tagResult.score * Self.kTagWeight
            }

            scoredCurriculum.append((curriculum: curriculum, score: totalScore))
        }

        var scoredCurriculumFiltered = scoredCurriculum.filter { $0.score > 0 }.prefix(15)
        scoredCurriculumFiltered.sort { $0.score > $1.score }

        return scoredCurriculumFiltered.map(\.curriculum)
    }

    // MARK: Private

    private nonisolated static let kTitleWeight = 10
    private nonisolated static let kSubtitleWeight = 3
    private nonisolated static let kTagWeight = 5

    @State private var query = ""
    @State private var isSearching = false
    @State private var searchActivityResults: [Activity] = []
    @State private var searchSkillsResults: [Skill] = []
    @State private var searchCurriculumResults: [Curriculum] = []

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
