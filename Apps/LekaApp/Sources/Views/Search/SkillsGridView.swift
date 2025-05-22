// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI
import UtilsKit

// MARK: - SkillsGridView

public struct SkillsGridView: View {
    // MARK: Lifecycle

    public init(skills: [Skill]? = nil) {
        self.skills = skills ?? []
    }

    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns) {
            ForEach(Array(self.skills.enumerated()), id: \.element.id) { index, skill in
                let subskills = Skills.getAllSubskills(for: skill)
                let filteredActivities = self.activities.filter {
                    $0.skills.contains(where: { activitySkill in subskills.contains(where: { $0 == activitySkill }) })
                }
                if !filteredActivities.isEmpty {
                    NavigationLink(destination:
                        SubskillsGridView(subskills: subskills)
                    ) {
                        GroupBox {
                            VStack {
                                Spacer()

                                if let icon = skill.iconImage {
                                    Image(uiImage: icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50)
                                }

                                Text(skill.name)
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .frame(height: 80)

                                Text(l10n.SkillsGridView.activityCountLabel(filteredActivities.count))
                                    .font(.caption.italic())
                                    .foregroundStyle(.white)
                            }
                        }
                        .backgroundStyle(self.backgroundColors[index % self.backgroundColors.count].gradient)
                    }
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let backgroundColors: [Color] = [.purple, .blue, .green, .orange, .teal, .pink, .mint, .red, .yellow, .cyan]

    let activities: [Activity] = ContentKit.allPublishedActivities.values.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    let skills: [Skill]

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
}

// MARK: - l10n.SkillsGridView

extension l10n {
    enum SkillsGridView {
        static let activityCountLabel = LocalizedStringInterpolation("lekapp.skills_grid_view.activity_count_label",
                                                                     value: "%d activity",
                                                                     comment: "Activity count label of SkillsGridView")
    }
}

#Preview {
    NavigationStack {
        SkillsGridView(
            skills: Skills.primarySkillsList
        )
    }
}
