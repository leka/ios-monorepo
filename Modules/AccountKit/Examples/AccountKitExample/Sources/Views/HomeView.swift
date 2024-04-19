// Leka - iOS Monorepo
// Copyright APF France handicap
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
            Text("Organisation is Logged In!")
                .fontWeight(.heavy)

            Button(
                action: {
                    self.authenticationState.organisationIsAuthenticated = .loggedOut
                },
                label: {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: 150)
            .tint(.red)
        }
        .padding()
        .navigationTitle("Home View")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    HomeView()
        .environmentObject(OrganisationAuthState())
}
