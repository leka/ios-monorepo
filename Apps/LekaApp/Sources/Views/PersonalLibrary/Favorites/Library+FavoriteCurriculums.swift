// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

struct FavoriteCurriculumsView: View {
    // MARK: Lifecycle

    init(viewModel: LibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.curriculums.isEmpty {
            EmptyFavoritesPlaceholderView(icon: .curriculums)
        } else {
            ScrollView(showsIndicators: true) {
                CurriculumGridView(curriculums: self.curriculums, onStartActivity: {
                    activity in
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
                        self.navigation.sheetContent = .carereceiverPicker(activity: activity, story: nil)
                    } else {
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                    }
                })
            }
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var viewModel: LibraryManagerViewModel
    private var authManagerViewModel: AuthManagerViewModel = .shared

    private var curriculums: [Curriculum] {
        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
            self.viewModel.curriculums.compactMap { savedCurriculum in
                guard self.viewModel.isCurriculumFavoritedByCurrentCaregiver(
                    curriculumID: savedCurriculum.id,
                    caregiverID: currentCaregiverID
                ) else {
                    return nil
                }
                return ContentKit.allPublishedCurriculums[savedCurriculum.id]
            }
            .sorted {
                $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
            }
        } else {
            []
        }
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    LibraryCurriculumsView(viewModel: viewModel)
}
