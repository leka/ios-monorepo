// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit

// MARK: - AuthManagerViewModel

@Observable
public class AuthManagerViewModel {
    // MARK: Lifecycle

    public init() {
        self.subscribeToAuthManager()
    }

    // MARK: Public

    public static let shared = AuthManagerViewModel()

    // MARK: - User

    public private(set) var userAuthenticationState: AuthManager.AuthenticationState = .unknown
    public private(set) var userAction: AuthManager.UserAction?
    public private(set) var userEmailIsVerified = false
    public private(set) var reAuthenticationSucceeded: Bool = false

    // MARK: - Alerts

    public private(set) var isLoading: Bool = false

    // TODO(@dev/team): Move the following to Views if relevant
    public var showErrorAlert = false
    public var resetPasswordSucceeded: Bool = false
    public var showErrorMessage = false
    public var showActionRequestAlert = false

    public func setLoading(_ loading: Bool) {
        self.isLoading = loading
    }

    public func setUserAction(_ action: AuthManager.UserAction?) {
        self.userAction = action
    }

    public func setUserEmailIsVerified(_ value: Bool) {
        self.userEmailIsVerified = value
    }

    public func setReAuthenticationSucceeded(_ value: Bool) {
        self.reAuthenticationSucceeded = value
    }

    public func resetErrorMessage() {
        self.showErrorAlert = false
        self.showErrorMessage = false
    }

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
        self.showActionRequestAlert = false
        self.showErrorAlert = false
        self.showErrorMessage = false

        self.userAction = .none
        self.userEmailIsVerified = false
        self.reAuthenticationSucceeded = false
    }
}
