// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ProfileEditorView: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

            Group {
                HStack(spacing: 40) {
                    Spacer()
                    ProfileSet_Teachers()
                    Spacer()
                    ProfileSet_Users()
                    Spacer()
                }
                .padding(.top, 60)
            }
        }
        .onAppear {
            if !settings.companyIsConnected {
                company.emptyProfilesSelection()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) { navigationTitle }
            ToolbarItem(placement: .navigationBarLeading) { backButton }
            ToolbarItem(placement: .navigationBarTrailing) { validateButton }
        }
    }

    // Toolbar
    private var navigationTitle: some View {
        HStack(spacing: 4) {
            Text("Choisir ou créer de nouveaux profils")
            if settings.companyIsConnected && settings.exploratoryModeIsOn {
                Image(systemName: "binoculars.fill")
            }
        }
        .font(metrics.semi17)
        .foregroundColor(.accentColor)
    }

    private var backButton: some View {
        Button(
            action: {
                // Leave without saving new selection
                viewRouter.currentPage = .home
            },
            label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Retour")
                }
            })
    }

    private var validateButton: some View {
        Button {
            if settings.companyIsConnected {
                if settings.exploratoryModeIsOn {
                    settings.showSwitchOffExploratoryAlert.toggle()
                } else {
                    // Save new selection and leave
                    company.assignCurrentProfiles()
                    viewRouter.currentPage = .home
                }
            } else {
                settings.showConnectInvite.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle")
                Text("Valider la sélection")
            }
            .foregroundColor(.accentColor)
        }
        .disabled(!settings.companyIsConnected)
        .disabled(!company.selectionSetIsCorrect())
    }
}

struct ProfileEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
