// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var authenticationState: OrganisationAuthState
    @State private var goBackToContentView: Bool = false

    var body: some View {
        switch authenticationState.organisationIsAuthenticated {
            case .unknown:
                Text("Loading...")
            case .loggedIn:
                content
            case .loggedOut:
                MainView()
        }
    }

    private var content: some View {
        VStack(spacing: 10) {
            Text("Organisation is Logged In!")
                .fontWeight(.heavy)

            Button(action: {
                authenticationState.organisationIsAuthenticated = .loggedOut
            }, label: {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
            })
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
