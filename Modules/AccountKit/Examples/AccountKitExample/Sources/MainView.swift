// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MainView: View {

    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            switch authManager.companyAuthenticationState {
                case .unknown:
                    Text("Loading...")
                case .loggedIn:
                    HomeView()
                        .transition(.opacity)
                case .loggedOut:
                    self.navigation
                        .transition(.opacity)
            }
        }
        .animation(
            .easeOut(duration: 0.4), value: authManager.companyAuthenticationState
        )
        .preferredColorScheme(.light)
    }

    // MARK: Private

    private var navigation: some View {
        NavigationStack {
            VStack(spacing: 10) {
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Log In").frame(width: 400)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink {
                    SignupView()
                } label: {
                    Text("Sign Up").frame(width: 400)
                }
                .buttonStyle(.bordered)
            }
            .buttonBorderShape(.roundedRectangle)
            .controlSize(.large)
            .navigationTitle("Authentication")
            .navigationBarBackButtonHidden()
            .alert("An error occurred", isPresented: $authManager.showErrorAlert) {
                // nothing to show
            } message: {
                Text(authManager.errorMessage)
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthManager())
}
