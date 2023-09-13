// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct GoButton: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                Button {
                    goButtonAction()
                } label: {
                    goButtonLabel
                }
                .background(Color("lekaLightGray"), in: Circle())
                .padding(.trailing, 40)
            }
            .offset(y: -40)
            Spacer()
        }
    }

    private func goButtonAction() {
        activityVM.setupGame(with: activityVM.currentActivity)
        guard robotVM.robotIsConnected || robotVM.userChoseToPlayWithoutRobot else {
            navigationVM.pathToGame = NavigationPath([PathsToGame.robot])
            navigationVM.showActivitiesFullScreenCover = true
            return
        }
        guard settings.companyIsConnected else {
            navigationVM.pathToGame = NavigationPath([PathsToGame.game])
            navigationVM.showActivitiesFullScreenCover = true
            return
        }
        guard company.selectionSetIsCorrect() else {
            navigationVM.pathToGame = NavigationPath([PathsToGame.user])
            navigationVM.showActivitiesFullScreenCover = true
            return
        }
        navigationVM.pathToGame = NavigationPath([PathsToGame.game])
        navigationVM.showActivitiesFullScreenCover = true
    }

    private var goButtonLabel: some View {
        ZStack {
            Circle()
                .inset(by: 6)
                .fill(Color("btnLightBlue"))
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 2.5)
            Circle()
                .inset(by: 8)
                .fill(Color.accentColor)
                .shadow(color: .black.opacity(0.2), radius: 2.5, x: 0, y: 2.6)
            Circle()
                .inset(by: 15)
                .stroke(.white, lineWidth: 2)
            Text("GO !")
                .foregroundColor(.white)
                .font(.system(size: 34, weight: .bold, design: .rounded))
        }
        .frame(width: 127, height: 127)
        .compositingGroup()
    }
}
