// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ProfileSelector_Users: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            ProfileSet_Users()
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
                .font(self.metrics.semi17)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
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
