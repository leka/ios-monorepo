// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit

// MARK: - l10n.AuthManagerViewModel

// swiftlint:disable line_length

extension l10n {
    enum AuthManagerViewModel {
        static let unverifiedEmailNotification = LocalizedString("accountkit.auth_manager_view_model.unverified_email_notification", value: "Your email hasn't been verified yet. Please verify your email to avoid losing your data.", comment: "Unverified email notification message")
    }
}

// MARK: - AuthManagerViewModel

// swiftlint:enable line_length

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
    @Published public var userIsSigningIn = false
    @Published public var userEmailIsVerified = false

    // MARK: - Alerts

    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false
    @Published public var actionRequestMessage: String = ""
    @Published public var showactionRequestAlert = false

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
                if !self.userIsSigningUp, !self.userEmailIsVerified {
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
        self.userIsSigningIn = false
        self.userEmailIsVerified = false
        self.errorMessage = ""
        self.actionRequestMessage = ""
        self.showactionRequestAlert = false
        self.showErrorAlert = false
    }
}
