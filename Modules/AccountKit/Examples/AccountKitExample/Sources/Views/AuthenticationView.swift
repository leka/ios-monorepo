// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import SwiftUI

struct AuthenticationView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            switch self.authManager.userAuthenticationState {
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
            .easeOut(duration: 0.4), value: self.authManager.userAuthenticationState
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
            .alert("An error occurred", isPresented: self.$authManager.showErrorAlert) {
                // nothing to show
            } message: {
                Text(self.authManager.errorMessage)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthManager())
}
