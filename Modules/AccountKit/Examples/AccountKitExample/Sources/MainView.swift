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
                    Text("Organisation is logged in.")
                case .loggedOut:
                    Text("Organisation is logged out.")
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
