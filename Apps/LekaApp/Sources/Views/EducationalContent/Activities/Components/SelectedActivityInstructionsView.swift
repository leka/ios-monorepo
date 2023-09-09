// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// Modal content when picking an activity within the ActivityList
struct SelectedActivityInstructionsView: View {

    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    private func goButtonAction() {
        activityVM.setupGame(with: activityVM.currentActivity)
        guard settings.companyIsConnected else {
            viewRouter.currentPage = .game
            return
        }
        guard robotVM.robotIsConnected else {
            // trigger robot FSC
            return
        }
        guard company.selectionSetIsCorrect() else {
            // trigger user selector FSC
            return
        }
        // trigger fullscreensavers here
        viewRouter.currentPage = .game
    }

    var body: some View {
        ZStack(alignment: .top) {
            // NavigationBar color
            Color("lekaLightBlue").ignoresSafeArea()

            // Background Color (only visible under the header here)
            Color.accentColor

            VStack(spacing: 0) {
                activityDetailHeader
                Rectangle()
                    .fill(Color("lekaLightGray"))
                    .edgesIgnoringSafeArea(.bottom)
                    .overlay { InstructionsView() }
                    .overlay { GoButton { goButtonAction() } }
            }
        }
        .preferredColorScheme(.light)
    }

    private var activityDetailHeader: some View {
        HStack {
            Spacer()
            Text(activityVM.currentActivity.title.localized())
                .font(metrics.semi17)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(width: 420, height: 90)
    }
}
