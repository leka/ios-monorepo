// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

struct CurriculumListView: View {
    // MARK: Internal

    let curriculums: [Curriculum] = ContentKit.listSampleCurriculums() ?? []

    var body: some View {
        ForEach(self.curriculums) { curriculum in
            NavigationLink(destination:
                CurriculumDetailsView(curriculum: curriculum, onActivitySelected: { activity in
//                self.selectedActivity = activity
                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                        self.navigation.sheetContent = .carereceiverPicker(activity: activity)
                    } else {
                        self.navigation.currentActivity = activity
                        self.navigation.fullScreenCoverContent = .activityView
                    }
                })
            ) {
                Image(uiImage: curriculum.details.iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                Text(curriculum.details.title)
            }
        }
    }

    // MARK: Private

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    CurriculumListView()
}
