// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SettingsSection_Account: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        Section {
            Group {
                Button("Se déconnecter") {
                    settings.showConfirmDisconnection.toggle()
                }
                .foregroundColor(.blue)
                Button("Supprimer le compte") {
                    settings.showConfirmDeleteAccount.toggle()
                }
                .foregroundColor(.red)
            }
            .frame(maxHeight: 52)
        }
        .alert("Déconnexion", isPresented: $settings.showConfirmDisconnection) {
            Button(role: .destructive) {
                viewRouter.currentPage = .welcome
                company.disconnect()
                robotVM.disconnect()
                settings.companyIsConnected = false
            } label: {
                Text("Se déconnecter")
            }
        } message: {
            Text("Vous êtes sur le point de vous déconnecter.")
        }
        .alert("Supprimer le compte", isPresented: $settings.showConfirmDeleteAccount) {
            Button(role: .destructive) {
                // For now...
                viewRouter.currentPage = .welcome
                company.disconnect()
                robotVM.disconnect()
                settings.companyIsConnected = false
            } label: {
                Text("Supprimer")
            }
        } message: {
            Text(  // swiftlint:disable:next line_length
                "Vous êtes sur le point de supprimer votre compte et toutes les données qu'il contient. \nCette action est irreversible. \nVoulez-vous continuer ?"
            )
        }
    }
}
