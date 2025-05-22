// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI
import UtilsKit

// MARK: - SubskillsGridView

public struct SubskillsGridView: View {
    // MARK: Lifecycle

    public init(subskills: [Skill]? = nil) {
        self.subskills = subskills ?? []
        guard let firstSubskill = subskills?.first else {
            self.mainSkillActivities = []
            return
        }
        self.mainSkillActivities = self.activities.filter {
            $0.skills.contains(firstSubskill)
        }.map { ContentCategory.CurationPayload(for: CurationItemModel(id: $0.id, contentType: .activity)) }
    }

    // MARK: Public

    public var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    let mainSkill = self.subskills[0]
                    if let icon = mainSkill.iconImage {
                        Image(uiImage: icon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 100)
                            .foregroundStyle(self.styleManager.accentColor!)
                    }

                    Text(mainSkill.description)
                        .font(.title2)
                }
                .padding(.horizontal)
                .padding(.bottom)

                Spacer()

                if self.subskills.count > 1 {
                    VStack(alignment: .leading, spacing: 30) {
                        ForEach(self.subskills[1...]) { subskill in
                            Section {
                                let subskillActivities = self.activities.filter {
                                    $0.skills.contains(subskill)
                                }.map { ContentCategory.CurationPayload(for: CurationItemModel(id: $0.id, contentType: .activity)) }
                                if !subskillActivities.isEmpty {
                                    VStack(alignment: .leading) {
                                        VStack(alignment: .leading) {
                                            Text(subskill.name)
                                                .font(.title2)
                                                .foregroundStyle(self.styleManager.accentColor!)

                                            Text(subskill.description)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(.horizontal)
                                        .padding(.horizontal)

                                        HorizontalActivityList(items: subskillActivities)

                                        Divider()
                                            .padding(.horizontal)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VerticalActivityGrid(items: self.mainSkillActivities)
                    }
                }
            }
        }
        .navigationTitle(self.subskills[0].name)
    }

    // MARK: Internal

    let backgroundColors: [Color] = [.purple, .blue, .green, .orange, .teal, .pink, .mint, .red, .yellow, .cyan]

    let activities: [Activity] = ContentKit.allPublishedActivities.values.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    let mainSkillActivities: [ContentCategory.CurationPayload]
    let subskills: [Skill]

    // MARK: Private

    private var styleManager: StyleManager = .shared
}

#Preview {
    NavigationStack {
        SubskillsGridView(
            subskills: Skills.primarySkillsList
        )
    }
}
