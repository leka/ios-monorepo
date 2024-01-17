// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SettingsSection_Account: View {
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var viewRouter: ViewRouterDeprecated

    var body: some View {
        Section {
            Group {
                Button("Se déconnecter") {
                    self.settings.showConfirmDisconnection.toggle()
                }
                .foregroundColor(.blue)
                Button("Supprimer le compte") {
                    self.settings.showConfirmDeleteAccount.toggle()
                }
                .foregroundColor(.red)
            }
            .frame(maxHeight: 52)
        }
        .alert("Déconnexion", isPresented: self.$settings.showConfirmDisconnection) {
            Button(role: .destructive) {
                self.viewRouter.currentPage = .welcome
                self.company.disconnect()
                self.robotVM.disconnect()
                self.settings.companyIsConnected = false
            } label: {
                Text("Se déconnecter")
            }
        } message: {
            Text("Vous êtes sur le point de vous déconnecter.")
        }
        .alert("Supprimer le compte", isPresented: self.$settings.showConfirmDeleteAccount) {
            Button(role: .destructive) {
                // For now...
                self.viewRouter.currentPage = .welcome
                self.company.disconnect()
                self.robotVM.disconnect()
                self.settings.companyIsConnected = false
            } label: {
                Text("Supprimer")
            }
        } message: {
            Text( // swiftlint:disable:next line_length
                "Vous êtes sur le point de supprimer votre compte et toutes les données qu'il contient. \nCette action est irreversible. \nVoulez-vous continuer ?"
            )
        }
    }
}
