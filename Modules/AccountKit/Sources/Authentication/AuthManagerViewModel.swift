// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class AuthManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(authManager: AuthManager = .shared) {
        self.authManager = authManager
        self.subscribeToAuthManager()
    }

    // MARK: Public

    // MARK: - User

    @Published public var userAuthenticationState: AuthManager.AuthenticationState = .unknown
    @Published public var userIsSigningUp = false

    // MARK: - Alerts

    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false
    @Published public var notificationMessage: String = ""
    @Published public var showNotificationAlert = false

    // MARK: - Authentication methods

    public func signUp(email: String, password: String) {
        self.userIsSigningUp = true
        self.authManager.signUp(email: email, password: password)
    }

    // MARK: Private

    private let authManager: AuthManager
    private var emailHasBeenConfirmed: Bool = false
    private var cancellables = Set<AnyCancellable>()

    private func subscribeToAuthManager() {
        self.authManager.authenticationStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.userAuthenticationState = state
                self?.handleAuthenticationStateChange(state: state)
            }
            .store(in: &self.cancellables)

        self.authManager.authenticationErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.showErrorAlert = true
            }
            .store(in: &self.cancellables)
    }

    private func handleAuthenticationStateChange(state: AuthManager.AuthenticationState) {
        switch state {
            case .loggedIn:
                if self.userIsSigningUp {
                    self.notificationMessage = "Verification email sent. Please check your inbox."
                    self.showNotificationAlert = true
                    // TODO(@macteuts): 'userIsSigningUp = false' on dismiss notification
                } else {
                    // Handle unverified Sign-in
                }
            case .loggedOut:
                log.info("User signed-out successfuly.")
                self.resetState()
            case .unknown:
                break
        }
    }

    private func resetState() {
        self.emailHasBeenConfirmed = false
        self.userIsSigningUp = false
        self.errorMessage = ""
        self.showErrorAlert = false
        self.notificationMessage = ""
        self.showNotificationAlert = false
    }
}
