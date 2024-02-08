// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit

public class AuthManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToAuthManager()
    }

    // MARK: Public

    public static let shared = AuthManagerViewModel()

    // MARK: - User

    @Published public var userAuthenticationState: AuthManager.AuthenticationState = .unknown
    @Published public var userIsSigningUp = false
    @Published public var userEmailIsVerified = false

    // MARK: - Alerts

    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false
    @Published public var actionRequestMessage: String = ""
    @Published public var showactionRequestAlert = false
    @Published public var notificationMessage: String = ""
    @Published public var showNotificationAlert = false
    @Published public var isWelcomeViewPresented = false

    // MARK: Private

    private let authManager: AuthManager = .shared
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
                if let authError = error as? AuthManager.AuthenticationError {
                    self?.errorMessage = authError.localizedDescription
                } else {
                    self?.errorMessage = error.localizedDescription
                }
                self?.showErrorAlert = true
            }
            .store(in: &self.cancellables)

        self.authManager.emailVerificationStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.userEmailIsVerified = state
            }
            .store(in: &self.cancellables)
    }

    private func handleAuthenticationStateChange(state: AuthManager.AuthenticationState) {
        switch state {
            case .loggedIn:
                if self.userIsSigningUp {
                    self.notificationMessage = String(l10n.AuthManagerViewModel.successfulEmailVerification.characters)
                    self.showNotificationAlert = true
                } else if !self.userEmailIsVerified {
                    self.actionRequestMessage = String(l10n.AuthManagerViewModel.unverifiedEmailNotification.characters)
                    self.showactionRequestAlert = true
                }
            case .loggedOut:
                self.resetState()
            case .unknown:
                break
        }
    }

    private func resetState() {
        self.userIsSigningUp = false
        self.userEmailIsVerified = false
        self.errorMessage = ""
        self.actionRequestMessage = ""
        self.showactionRequestAlert = false
        self.showErrorAlert = false
        self.notificationMessage = ""
        self.showNotificationAlert = false
        self.isWelcomeViewPresented = true
    }
}
