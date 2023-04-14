// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ProfileSelector_Teachers: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            ProfileSet_Teachers()
                .padding(.top, 60)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4) {
                    if settings.companyIsConnected && settings.exploratoryModeIsOn {
                        Image(systemName: "binoculars.fill")
                    }
                    Text("Choisir ou créer de nouveaux profils")
                }
                .font(metrics.semi17)
                .foregroundColor(.accentColor)
            }
        }
    }
}
