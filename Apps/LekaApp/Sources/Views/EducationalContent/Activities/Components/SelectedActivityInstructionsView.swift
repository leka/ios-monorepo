// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SelectedActivityInstructionsView: View {

    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    private func goButtonAction() {
        activityVM.setupGame(with: activityVM.currentActivity)
        guard robotVM.robotIsConnected || robotVM.userChoseToPlayWithoutRobot else {
            sidebar.pathToGame = NavigationPath([PathsToGame.robot])
            sidebar.showActivitiesFullScreenCover = true
            return
        }
        guard settings.companyIsConnected else {
            sidebar.pathToGame = NavigationPath([PathsToGame.game])
            sidebar.showActivitiesFullScreenCover = true
            return
        }
        guard company.selectionSetIsCorrect() else {
            sidebar.pathToGame = NavigationPath([PathsToGame.user])
            sidebar.showActivitiesFullScreenCover = true
            return
        }
        sidebar.pathToGame = NavigationPath([PathsToGame.game])
        sidebar.showActivitiesFullScreenCover = true
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
        .fullScreenCover(isPresented: $sidebar.showActivitiesFullScreenCover) {
            FullScreenCoverToGameView()
        }
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
