// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HomeView: View {
    // MARK: Internal

    @EnvironmentObject var authenticationState: OrganisationAuthState

    var body: some View {
        switch self.authenticationState.organisationIsAuthenticated {
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

    private var content: some View {
        VStack(spacing: 10) {
            Text("Company is Logged In!")
                .fontWeight(.heavy)

            HStack(spacing: 10) {
                Button(
                    action: {
                        authManager.signOut()
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
                        showDeleteConfirmation.toggle()
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
        .alert("Supprimer le compte", isPresented: $showDeleteConfirmation) {
            Button(role: .destructive) {
                authManager.deleteAccount()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dismiss()
                }
            } label: {
                Text("Supprimer")
            }
        } message: {
            Text(
                "Vous êtes sur le point de supprimer le compte de votre établissemnt. \nCette action est irreversible."
            )
        }
        .alert("Email non-vérifié", isPresented: $authManager.showactionRequestAlert) {
            Button(role: .none) {
                authManager.sendEmailVerification()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dismiss()
                }
            } label: {
                Text("Renvoyer")
            }
            Button(role: .cancel) {
                dismiss()
            } label: {
                Text("Plus tard")
            }
        } message: {
            Text(authManager.actionRequestMessage)
        }
        .alert("Vérification de votre email", isPresented: $authManager.showNotificationAlert) {
            // nothing to show
        } message: {
            Text(authManager.notificationMessage)
        }
        .alert("An error occurred", isPresented: $authManager.showErrorAlert) {
            // nothing to show
        } message: {
            Text(authManager.errorMessage)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
