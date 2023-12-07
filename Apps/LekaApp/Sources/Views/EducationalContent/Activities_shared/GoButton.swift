// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct GoButton: View {
    // MARK: Internal

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
                    self.goButtonAction()
                } label: {
                    self.goButtonLabel
                }
                .background(DesignKitAsset.Colors.lekaLightGray.swiftUIColor, in: Circle())
                .padding(.trailing, 40)
            }
            .offset(y: -40)
            Spacer()
        }
    }

    // MARK: Private

    private var goButtonLabel: some View {
        ZStack {
            Circle()
                .inset(by: 6)
                .fill(DesignKitAsset.Colors.lekaLightBlue.swiftUIColor)
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 2.5)
            Circle()
                .inset(by: 8)
                .fill(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
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

    private func goButtonAction() {
        self.activityVM.setupGame(with: self.activityVM.currentActivity)
        guard self.robotVM.robotIsConnected || self.robotVM.userChoseToPlayWithoutRobot else {
            self.navigationVM.pathToGame = NavigationPath([PathsToGame.robot])
            self.navigationVM.showActivitiesFullScreenCover = true
            return
        }
        guard self.settings.companyIsConnected else {
            self.navigationVM.pathToGame = NavigationPath([PathsToGame.game])
            self.navigationVM.showActivitiesFullScreenCover = true
            return
        }
        guard self.company.selectionSetIsCorrect() else {
            self.navigationVM.pathToGame = NavigationPath([PathsToGame.user])
            self.navigationVM.showActivitiesFullScreenCover = true
            return
        }
        self.navigationVM.pathToGame = NavigationPath([PathsToGame.game])
        self.navigationVM.showActivitiesFullScreenCover = true
    }
}
