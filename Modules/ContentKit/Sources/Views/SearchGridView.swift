// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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

                HStack(spacing: 20) {
                    ForEach(Array(self.activities[0..<min(3, self.activities.count)])) { activity in
                        NavigationLink(destination:
                            ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
                        ) {
                            VStack {
                                Image(uiImage: activity.details.iconImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 120)
                                    .overlay(
                                        Circle()
                                            .stroke(self.styleManager.accentColor!.opacity(0.2), lineWidth: 5)
                                    )
                                    .padding(.bottom, 15)

                                Text(activity.details.title)
                                    .font(.headline)
                                    .foregroundStyle(Color.primary)
                                Text(activity.details.subtitle ?? "")
                                    .font(.body)
                                    .foregroundStyle(Color.secondary)

                                Spacer()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.bottom)
            }

            if !self.curriculums.isEmpty {
                HStack {
                    Text(l10n.SearchGridView.curriculumsTitle)
                        .font(.title.bold())
                    Spacer()
                    NavigationLink(destination:
                        ScrollView(showsIndicators: true) {
                            CurriculumGridView(curriculums: self.curriculums, onActivitySelected: self.onStartActivity)
                                .navigationTitle(String(l10n.SearchGridView.curriculumsTitle.characters))
                        }
                    ) {
                        Text(l10n.SearchGridView.seeAllLabel)
                    }
                }

                HStack(spacing: 20) {
                    ForEach(Array(self.curriculums[0..<min(3, self.curriculums.count)])) { curriculum in
                        NavigationLink(destination:
                            CurriculumDetailsView(curriculum: curriculum, onActivitySelected: self.onStartActivity)
                        ) {
                            GroupBox {
                                VStack(spacing: 10) {
                                    Image(uiImage: curriculum.details.iconImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * 150))

                                    Text(curriculum.details.title)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Color.primary)

                                    Text(curriculum.details.subtitle ?? "")
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Color.secondary)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }

            if !self.skills.isEmpty {
                HStack {
                    Text(l10n.SearchGridView.skillsTitle)
                        .font(.title.bold())
                    Spacer()
                }
                SkillsGridView(skills: self.skills, onActivitySelected: self.onStartActivity)
            }
        }
        .padding(.horizontal)
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
        static let activitiesTitle = LocalizedString("content_kit.search_grid_view.activities_title",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Activities",
                                                     comment: "SearchGridView 'activities' section title")

        static let curriculumsTitle = LocalizedString("content_kit.search_grid_view.curriculums_title",
                                                      bundle: ContentKitResources.bundle,
                                                      value: "Curriculums",
                                                      comment: "SearchGridView 'curriculums' section title")

        static let skillsTitle = LocalizedString("content_kit.search_grid_view.skills_title",
                                                 bundle: ContentKitResources.bundle,
                                                 value: "Skills",
                                                 comment: "SearchGridView 'skills' section title")

        static let seeAllLabel = LocalizedString("content_kit.search_grid_view.see_all_label",
                                                 bundle: ContentKitResources.bundle,
                                                 value: "See all",
                                                 comment: "SearchGridView 'see all' button label")

        static let noResults = LocalizedString("content_kit.search_grid_view.no_results",
                                               bundle: ContentKitResources.bundle,
                                               value: "Oops! No results found.",
                                               comment: "SearchGridView 'see all' button label")
    }
}

#Preview {
    NavigationStack {
        SearchGridView(
            activities: ContentKit.allActivities,
            skills: Skills.primarySkillsList,
            curriculums: ContentKit.allCurriculums,
            onStartActivity: { _ in
                print("Activity Started")
            }
        )
    }
}
