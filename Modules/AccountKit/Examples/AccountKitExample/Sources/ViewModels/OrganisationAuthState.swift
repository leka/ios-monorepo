// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class OrganisationAuthState: ObservableObject {
    enum FirebaseAuthenticationState {
        case unknown
        case loggedOut
        case loggedIn
    }

    @Published var organisationIsAuthenticated: FirebaseAuthenticationState = .unknown

    func updateAuthState() {
        self.organisationIsAuthenticated = .loggedOut // for now...
    }
}
