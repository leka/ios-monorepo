// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - HorizontalCurriculumContentGrid

public struct HorizontalCurriculumContentGrid: View {
    // MARK: Public

    public var body: some View {
        if let content = self.curriculumContent {
            VStack(alignment: .leading, spacing: 5) {
                self.curriculumHeader(item: content.item, curriculum: content.curriculum)
                    .padding(.horizontal)

                HorizontalActivityGrid(items: self.activityItems(from: content.curriculum))
            }
        }
    }

    // MARK: Internal

    let items: [CurationItemModel]

    // MARK: Private

    @State private var navigation: Navigation = .shared

    private let kIconSize: CGFloat = 100

    private var curriculumContent: (item: CurationItemModel, curriculum: Curriculum)? {
        for item in self.items where item.contentType == .curriculum {
            if let curriculum = Curriculum(id: item.id) {
                return (item, curriculum)
            }
        }

        return nil
    }

    private func curriculumHeader(item: CurationItemModel, curriculum: Curriculum) -> some View {
        NavigationLink(destination:
            AnyView(self.navigation.curationDestination(item)))
        {
            HStack(alignment: .top, spacing: 20) {
                Image(uiImage: curriculum.details.iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.kIconSize, height: self.kIconSize)
                    .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize))

                VStack(alignment: .leading, spacing: 8) {
                    Text(curriculum.details.title)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primary)

                    if let subtitle = curriculum.details.subtitle, subtitle != "" {
                        Text(subtitle)
                            .font(.headline)
                            .foregroundStyle(Color.secondary)
                    }

                    Text(curriculum.details.abstract)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(3)
                }
                .multilineTextAlignment(.leading)

                Spacer()

                VStack {
                    Text(curriculum.activities.count.description)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.primary)

                    Text(l10n.HorizontalCurriculumContentGrid.activitiesLabel)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .simultaneousGesture(TapGesture().onEnded {
            AnalyticsManager.logEventSelectContent(
                type: .curriculum,
                id: item.id,
                name: item.name,
                origin: self.navigation.selectedCategory?.rawValue
            )
        })
    }

    private func activityItems(from curriculum: Curriculum) -> [CurationItemModel] {
        curriculum.activities.compactMap { activityID in
            guard let activity = Activity(id: activityID) else { return nil }
            return CurationItemModel(id: activity.id, name: activity.name, contentType: .activity)
        }
    }
}

// MARK: - l10n.HorizontalCurriculumContentGrid

extension l10n {
    enum HorizontalCurriculumContentGrid {
        static let activitiesLabel = LocalizedString("lekaapp.horizontal_curriculum_content_grid.activities_label",
                                                     value: "Activities",
                                                     comment: "HorizontalCurriculumContentGrid 'activities' count label")
    }
}

#Preview {
    let curriculum = ContentKit.allCurriculums.first!.value

    ScrollView {
        HorizontalCurriculumContentGrid(
            items: [CurationItemModel(id: curriculum.id, name: curriculum.name, contentType: .curriculum)]
        )
    }
}
