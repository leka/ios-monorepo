// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit
import Observation

// MARK: - AuthManagerViewModel

@Observable
public class AuthManagerViewModel {
    // MARK: Lifecycle

    public init() {
        self.subscribeToAuthManager()
    }

    // MARK: Public

    @ObservationIgnored public static let shared = AuthManagerViewModel()

    // MARK: - User

    public var userAuthenticationState: AuthManager.AuthenticationState = .unknown
    public var userAction: AuthManager.UserAction?
    public var userEmailIsVerified = false
    public var reAuthenticationSucceeded: Bool = false

    // MARK: - Alerts

    public var showErrorAlert = false
    public var showErrorMessage = false
    public var showActionRequestAlert = false
    public var resetPasswordSucceeded: Bool = false
    public var isLoading: Bool = false

    public func resetErrorMessage() {
        self.showErrorAlert = false
        self.showErrorMessage = false
    }

    // MARK: Private

    @ObservationIgnored private let authManager: AuthManager = .shared
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

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
            .sink { [weak self] _ in
                switch self?.userAction {
                    case .userIsSigningOut,
                         .userIsDeletingAccount,
                         .userIsResettingPassword:
                        self?.showErrorAlert = true
                    default:
                        self?.showErrorMessage = true
                }
            }
            .store(in: &self.cancellables)

        self.authManager.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &self.cancellables)

        self.authManager.emailVerificationStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.userEmailIsVerified = state
            }
            .store(in: &self.cancellables)

        self.authManager.reAuthenticationStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.reAuthenticationSucceeded = state
            }
            .store(in: &self.cancellables)

        self.authManager.passwordResetEmailPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.resetPasswordSucceeded = state
            }
            .store(in: &self.cancellables)
    }

    private func handleAuthenticationStateChange(state: AuthManager.AuthenticationState) {
        switch state {
            case .loggedIn:
                if self.userAction == .none {
                    self.showActionRequestAlert = true
                }
                self.resetErrorMessage()
            case .loggedOut:
                self.resetState()
            case .unknown:
                self.resetState()
        }
    }

    private func resetState() {
        self.userAction = .none
        self.userEmailIsVerified = false
        self.showActionRequestAlert = false
        self.showErrorAlert = false
        self.showErrorMessage = false
        self.reAuthenticationSucceeded = false
    }
}
