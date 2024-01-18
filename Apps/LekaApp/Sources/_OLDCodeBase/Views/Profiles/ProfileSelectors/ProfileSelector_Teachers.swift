// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ProfileSelector_Teachers: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            ProfileSet_Teachers()
                .padding(.top, 60)
        }
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
        }
    }
}
