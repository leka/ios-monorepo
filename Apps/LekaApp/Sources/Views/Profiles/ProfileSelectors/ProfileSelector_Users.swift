// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ProfileSelector_Users: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            ProfileSet_Users()
                .padding(.top, 60)
        }
        .navigationBarBackButtonHidden()
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        if viewRouter.currentPage == .game {
                            withAnimation {
                                viewRouter.currentPage = .home
                            }
                        }
                        viewRouter.pathFromCurriculum = .init()
                    },
                    label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Retour")
                        }
                    })
            }
        }
    }
}
