// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI
import UtilsKit

// MARK: - SkillsGridView

public struct SkillsGridView: View {
    // MARK: Lifecycle

    public init(skills: [Skill]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.skills = skills ?? []
        self.onActivitySelected = onActivitySelected
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
                        ScrollView(showsIndicators: true) {
                            ActivityGridView(activities: filteredActivities, onStartActivity: self.onActivitySelected)
                        }
                        .navigationTitle(skill.name)
                    ) {
                        GroupBox {
                            VStack {
                                Spacer()
                                Text(skill.name)
                                    .font(.largeTitle.bold())
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .frame(height: 150)

                                Text(l10n.SkillsGridView.activityCountLabel(filteredActivities.count))
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .padding()
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

    let activities: [Activity] = ContentKit.allActivities.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    let skills: [Skill]
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 2)
}

// MARK: - l10n.SkillsGridView

extension l10n {
    enum SkillsGridView {
        static let activityCountLabel = LocalizedStringInterpolation("lekaapp.skills_grid_view.activity_count_label",
                                                                     value: "%d activity",
                                                                     comment: "Activity count label of SkillsGridView")
    }
}

#Preview {
    NavigationStack {
        SkillsGridView(
            skills: Skills.primarySkillsList,
            onActivitySelected: { _ in
                print("Activity Selected")
            }
        )
    }
}
