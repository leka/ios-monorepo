// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import SwiftUI

struct HomeView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        switch self.authManager.companyAuthenticationState {
            case .unknown:
                Text("Loading...")
            case .loggedIn:
                self.content
            case .loggedOut:
                MainView()
        }
    }

    // MARK: Private

    @State private var goBackToContentView: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var showErrorAlert = false

    private var content: some View {
        VStack(spacing: 10) {
            Text("Company is Logged In!")
                .fontWeight(.heavy)

            HStack(spacing: 10) {
                Button(
                    action: {
                        self.authManager.signOut()
                    },
                    label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(.bordered)
                .frame(maxWidth: 200)

                Button(
                    action: {
                        self.showDeleteConfirmation.toggle()
                    },
                    label: {
                        Text("Delete Company")
                            .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: 200)
                .tint(.red)
            }
        }
        .padding()
        .alert("Supprimer le compte", isPresented: self.$showDeleteConfirmation) {
            Button(role: .destructive) {
                self.authManager.deleteAccount()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss()
                }
            } label: {
                Text("Supprimer")
            }
        } message: {
            Text(
                "Vous êtes sur le point de supprimer le compte de votre établissemnt. \nCette action est irreversible."
            )
        }
        .alert("Email non-vérifié", isPresented: self.$authManager.showactionRequestAlert) {
            Button(role: .none) {
                self.authManager.sendEmailVerification()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss()
                }
            } label: {
                Text("Renvoyer")
            }
            Button(role: .cancel) {
                self.dismiss()
            } label: {
                Text("Plus tard")
            }
        } message: {
            Text(self.authManager.actionRequestMessage)
        }
        .alert("Vérification de votre email", isPresented: self.$authManager.showNotificationAlert) {
            // nothing to show
        } message: {
            Text(self.authManager.notificationMessage)
        }
        .alert("An error occurred", isPresented: self.$showErrorAlert) {
            // nothing to show
        } message: {
            Text(self.authManager.errorMessage)
        }
        .onReceive(self.authManager.$showErrorAlert) { newValue in
            self.showErrorAlert = newValue
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
