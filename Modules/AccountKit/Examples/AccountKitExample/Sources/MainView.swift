// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MainView: View {
    // MARK: Internal

    @EnvironmentObject var authenticationState: OrganisationAuthState

    var body: some View {
        Group {
            switch authenticationState.organisationIsAuthenticated {
                case .unknown:
                    Text("Loading...")
                case .loggedIn:
                    HomeView()
                        .transition(.opacity)
                case .loggedOut:
                    navigation
                        .transition(.opacity)
            }
        }
        .animation(
            .easeOut(duration: 0.4),
            value: authenticationState.organisationIsAuthenticated
        )
        .preferredColorScheme(.light)
        .onAppear(perform: {
            authenticationState.organisationIsAuthenticated = .loggedOut
        })
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
        }
    }
}

#Preview {
    MainView()
        .environmentObject(OrganisationAuthState())
}
