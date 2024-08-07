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

                                if let icon = UIImage(named: "\(skill.id).skill.icon.png", in: .module, with: nil) {
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

    let activities: [Activity] = ContentKit.allPublishedActivities.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    let skills: [Skill]
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.SkillsGridView

extension l10n {
    enum SkillsGridView {
        static let activityCountLabel = LocalizedStringInterpolation("content_kit.skills_grid_view.activity_count_label",
                                                                     bundle: ContentKitResources.bundle,
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
