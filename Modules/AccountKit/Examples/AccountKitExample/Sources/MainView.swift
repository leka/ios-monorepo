// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MainView: View {

    @EnvironmentObject var authenticationState: OrganisationAuthState

    var body: some View {
        Group {
            switch authenticationState.organisationIsAuthenticated {
                case .unknown:
                    Text("Loading...")
                case .loggedIn:
                    HomeView()
                case .loggedOut:
                    LoginView()
            }
        }
        .preferredColorScheme(.light)
        .onAppear(perform: {
            authenticationState.organisationIsAuthenticated = .loggedOut
        })
    }

}

#Preview {
    MainView()
        .environmentObject(OrganisationAuthState())
}
