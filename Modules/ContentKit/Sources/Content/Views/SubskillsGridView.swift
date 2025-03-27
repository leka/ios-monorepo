// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI
import UtilsKit

// MARK: - SubskillsGridView

public struct SubskillsGridView: View {
    // MARK: Lifecycle

    public init(subskills: [Skill]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.subskills = subskills ?? []
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    let mainSkill = self.subskills[0]
                    if let icon = UIImage(named: "\(mainSkill.id).skill.png", in: .module, with: nil) {
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
                                }
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

                                        ActivityHorizontalListView(activities: subskillActivities, onActivitySelected: self.onActivitySelected)

                                        Divider()
                                            .padding(.horizontal)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ScrollView(showsIndicators: true) {
                        ActivityGridView(activities: self.activities.filter {
                            $0.skills.contains(self.subskills[0])
                        }, onStartActivity: self.onActivitySelected)
                    }
                }
            }
        }
        .navigationTitle(self.subskills[0].name)
    }

    // MARK: Internal

    let backgroundColors: [Color] = [.purple, .blue, .green, .orange, .teal, .pink, .mint, .red, .yellow, .cyan]

    let activities: [Activity] = ContentKit.allPublishedActivities.sorted {
        $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
    }

    let subskills: [Skill]
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    private let columns = Array(repeating: GridItem(), count: 2)
}

#Preview {
    NavigationStack {
        SubskillsGridView(
            subskills: Skills.primarySkillsList,
            onActivitySelected: { _ in
                print("Activity Selected")
            }
        )
    }
}
