// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import Fit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - CurriculumDetailsView

public struct CurriculumDetailsView: View {
    // MARK: Lifecycle

    public init(curriculum: Curriculum) {
        self.curriculum = curriculum
    }

    // MARK: Public

    public var body: some View {
        List {
            InfoDetailsView(CurationItemModel(id: self.curriculum.id, name: self.curriculum.name, contentType: .curriculum))

            Section(String(l10n.CurriculumDetailsView.activitiesSectionTitle.characters)) {
                ScrollView(showsIndicators: true) {
                    VerticalActivityList(items:
                        self.curriculum.activities.compactMap {
                            guard let activity = Activity(id: $0) else { return nil }
                            return CurationItemModel(id: activity.id, name: activity.name, contentType: .activity)
                        }
                    )
                }
            }
        }
        .toolbar {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ToolbarItemGroup {
                    if self.sharedLibraryManagerViewModel.isCurriculumFavoritedByCurrentCaregiver(
                        curriculumID: self.curriculum.uuid,
                        caregiverID: currentCaregiverID
                    ) {
                        Image(systemName: "star.circle")
                            .font(.system(size: 21))
                            .foregroundColor(self.styleManager.accentColor ?? .blue)
                    }

                    ContentItemMenu(
                        CurationItemModel(id: self.curriculum.uuid, name: self.curriculum.name, contentType: .curriculum),
                        caregiverID: currentCaregiverID
                    )
                }
            }
        }
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared
    private let curriculum: Curriculum
}

// MARK: - l10n.CurriculumDetailsView

extension l10n {
    enum CurriculumDetailsView {
        static let activitiesSectionTitle = LocalizedString("lekaapp.curriculum_details_view.activities_section_title",
                                                            value: "Activities",
                                                            comment: "CurriculumDetailsView 'activities' section title")
    }
}

#Preview {
    NavigationStack {
        CurriculumDetailsView(curriculum: Curriculum.mock)
    }
}
