// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ProfileSelector_UsersDeprecated: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            ProfileSet_UsersDeprecated()
                .padding(.top, 60)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4) {
                    if self.settings.companyIsConnected, self.settings.exploratoryModeIsOn {
                        Image(systemName: "binoculars.fill")
                    }
                    Text("Choisir ou créer de nouveaux profils")
                }
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        self.navigationVM.showActivitiesFullScreenCover = false
                    },
                    label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Retour")
                        }
                    }
                )
            }
        }
    }
}
