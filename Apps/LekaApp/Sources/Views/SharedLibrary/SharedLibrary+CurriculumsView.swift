// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

struct SharedLibraryCurriculumsView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.curriculums.isEmpty {
            EmptySharedLibraryPlaceholderView(icon: .curriculums)
        } else {
            ScrollView(showsIndicators: true) {
                CurriculumGridView(curriculums: self.curriculums, onStartActivity: {
                    activity in
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
                        self.navigation.setSheetContent(.carereceiverPicker(activity: activity, story: nil))
                    } else {
                        self.navigation.setCurrentActivity(activity)
                        self.navigation.setFullScreenCoverContent(.activityView(carereceivers: []))
                    }
                })
            }
        }
    }

    // MARK: Private

    private var navigation: Navigation = .shared
    private var viewModel: SharedLibraryManagerViewModel
    private var authManagerViewModel: AuthManagerViewModel = .shared

    private var curriculums: [Curriculum] {
        self.viewModel.curriculums.compactMap { savedCurriculums in
            ContentKit.allCurriculums[savedCurriculums.id]
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    SharedLibraryCurriculumsView(viewModel: viewModel)
}
