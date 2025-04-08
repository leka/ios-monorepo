// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

struct LibraryCurriculumsView: View {
    // MARK: Lifecycle

    init(viewModel: LibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.curriculums.isEmpty {
            EmptyLibraryPlaceholderView(icon: .curriculums)
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
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    private var viewModel: LibraryManagerViewModel

    private var curriculums: [Curriculum] {
        self.viewModel.curriculums.compactMap { savedCurriculums in
            ContentKit.allCurriculums.first { $0.id == savedCurriculums.id }
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = LibraryManagerViewModel()
    LibraryCurriculumsView(viewModel: viewModel)
}
