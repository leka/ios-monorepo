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

    let activities: [Activity] = ContentKit.allPublishedActivities.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    let skills: [Skill] = Skills.primarySkillsList

    var body: some View {
        Group {
            if self.searchText.isEmpty {
                ScrollView(showsIndicators: true) {
                    SkillsGridView(skills: self.skills, onActivitySelected: { activity in
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                    })
                }
            } else {
                ScrollView(showsIndicators: true) {
                    ActivityGridView(activities: self.searchResults, onStartActivity: { activity in
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                    })
                }
            }
        }
        .searchable(text: self.$searchText, suggestions: {
            ForEach(self.filteredActivitySuggestions, id: \.self) { suggestion in
                Text(l10n.CategorySearchView.activitySuggestion(suggestion))
                    .searchCompletion(suggestion)
            }
            ForEach(self.filteredSkillSuggestions, id: \.self) { suggestion in
                Text(l10n.CategorySearchView.skillSuggestion(suggestion.name))
                    .searchCompletion(suggestion.name)
            }
        })
        .navigationTitle(String(l10n.CategorySearchView.title.characters))
    }

    var searchResults: [Activity] {
        if self.searchText.isEmpty {
            self.activities
        } else {
            self.activities.filter { activity in

                activity.details.title.lowercased().contains(self.searchText.lowercased()) ||
                    activity.skills.contains(where: { $0.name.lowercased().contains(self.searchText.lowercased()) })
            }
        }
    }

    var filteredActivitySuggestions: [String] {
        guard !self.searchText.isEmpty else { return [] }
        let suggestions = self.activities.filter { $0.details.title.lowercased().contains(self.searchText.lowercased()) }
            .map(\.details.title)
            .removingDuplicates()
        return Array(suggestions[0..<min(3, suggestions.count)])
    }

    var filteredSkillSuggestions: [Skill] {
        guard !self.searchText.isEmpty else { return [] }
        let suggestions = Skills.allSkillsList.filter { skill in
            (skill.name.lowercased().contains(self.searchText.lowercased()) &&
                self.activities.filter { $0.skills.contains(where: { $0 == skill }) }.isNotEmpty)
        }
        return Array(suggestions[0..<min(3, suggestions.count)])
    }

    // MARK: Private

    @State private var searchText = ""
    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

// MARK: - l10n.CategorySearchView

extension l10n {
    enum CategorySearchView {
        static let title = LocalizedString("lekaapp.category_search_view.title",
                                           value: "Search",
                                           comment: "Search title")

        static let activitySuggestion = LocalizedStringInterpolation("lekaapp.category_search_view.activity_suggestion",
                                                                     value: "Activity: %@",
                                                                     comment: "Activity suggestion label when searching")

        static let skillSuggestion = LocalizedStringInterpolation("lekaapp.category_search_view.skill_suggestion",
                                                                  value: "Skill: %@",
                                                                  comment: "Skill suggestion label when searching")
    }
}

#Preview {
    CategorySearchView()
}
