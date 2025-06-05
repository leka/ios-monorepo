// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
import SwiftUI

// MARK: - VerticalActivityList

struct VerticalActivityList: View {
    // MARK: Internal

    let items: [CurationItemModel]

    var body: some View {
        ScrollView {
            Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 24) {
                ForEach(Array(self.items.enumerated()), id: \.offset) { index, item in
                    GridRow {
                        NavigationLink(destination:
                            AnyView(self.navigation.curationDestination(item))
                        ) {
                            ActivityListItem(item, number: index)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, maxHeight: 120)
                        .simultaneousGesture(TapGesture().onEnded {
                            AnalyticsManager.logEventSelectContent(
                                type: item.contentType == .activity ? .activity : .story,
                                id: item.id,
                                name: item.name,
                                origin: self.navigation.selectedCategory?.rawValue
                            )
                        })

                        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                            ContentItemMenu(
                                item,
                                caregiverID: currentCaregiverID
                            )
                            .frame(width: 40)
                        }

                        QuickStartButton(item: item)
                    }
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: Private

    @State private var navigation: Navigation = .shared
    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        VerticalActivityList(
            items: sandboxCuration.sections[2].items
        )
    }
}
