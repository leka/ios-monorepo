// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - VerticalActivityTable

struct VerticalActivityTable: View {
    // MARK: Internal

    let items: [CurationItemModel]

    var body: some View {
        Table(self.items) {
            TableColumn(String(l10n.VerticalActivityTable.titleColumnLabel.characters)) { item in
                NavigationLink(destination:
                    AnyView(self.navigation.curationDestination(item))
                ) {
                    ActivityTableItem(item)
                }
                .buttonStyle(.plain)
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.logEventSelectContent(
                        type: item.contentType == .activity ? .activity : .story,
                        id: item.id,
                        name: item.name,
                        origin: self.navigation.selectedCategory?.rawValue
                    )
                })
            }
            .width(min: 400, ideal: 450, max: .infinity)

            TableColumn("") { item in
                if let activity = Activity(id: item.id) {
                    IconImageView(image: ContentKit.getGestureIconUIImage(for: activity))
                }
            }
            .width(40)

            TableColumn("") { item in
                if let activity = Activity(id: item.id) {
                    IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .ears))
                }
            }
            .width(40)

            TableColumn("") { item in
                if let activity = Activity(id: item.id) {
                    IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .robot))
                }
            }
            .width(60)

            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                TableColumn("") { item in
                    ContentItemMenu(
                        item,
                        caregiverID: currentCaregiverID
                    )
                }
                .width(40)
            }

            TableColumn("") { item in
                QuickStartButton(item: item)
            }
            .width(80)
        }
        .tableStyle(.inset)
    }

    // MARK: Private

    @State private var navigation: Navigation = .shared
    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()
}

// MARK: - l10n.VerticalActivityTable

extension l10n {
    enum VerticalActivityTable {
        static let titleColumnLabel = LocalizedString(
            "lekaapp.vertical_activity_table.title_column_label",
            value: "Title",
            comment: "Title Column header label in the Vertical Activity Table views"
        )
    }
}

#Preview {
    let sandboxCuration = ContentKit.allCurations[MainCurations.sandbox.rawValue]!

    ScrollView {
        VerticalActivityList(
            items: sandboxCuration.sections[2].items
        )
    }
}
