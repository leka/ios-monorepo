// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import LocalizationKit

// MARK: - AuthManagerViewModel

public class AuthManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToAuthManager()
    }

    // MARK: Public

    public static let shared = AuthManagerViewModel()

    // MARK: - User

    @Published public var userAuthenticationState: AuthManager.AuthenticationState = .unknown
    @Published public var userAction: AuthManager.UserAction?
    @Published public var userEmailIsVerified = false
    @Published public var reAuthenticationSucceeded: Bool = false

    // MARK: - Alerts

    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false
    @Published public var showErrorMessage = false
    @Published public var actionRequestMessage: String = ""
    @Published public var showActionRequestAlert = false
    @Published public var isLoading: Bool = false

    public func resetErrorMessage() {
        self.errorMessage = ""
        self.showErrorAlert = false
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
            .sink { [weak self] error in
                if let authError = error as? AuthManager.AuthenticationError {
                    self?.errorMessage = authError.localizedDescription
                } else {
                    self?.errorMessage = error.localizedDescription
                }
                if self?.userAction == .userIsSigningOut {
                    self?.showErrorAlert = true
                } else {
                    self?.showErrorMessage = true
                }
            }
            .store(in: &self.cancellables)

        self.authManager.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$isLoading)

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
    }

    private func handleAuthenticationStateChange(state: AuthManager.AuthenticationState) {
        switch state {
            case .loggedIn:
                if self.userAction == .none {
                    self.actionRequestMessage = String(l10n.AuthManagerViewModel.unverifiedEmailNotification.characters)
                    self.showActionRequestAlert = true
                }
                self.resetErrorMessage()
            case .loggedOut:
                self.resetState()
            case .unknown:
                break
        }
    }

    private func resetState() {
        self.userAction = .none
        self.userEmailIsVerified = false
        self.errorMessage = ""
        self.actionRequestMessage = ""
        self.showActionRequestAlert = false
        self.showErrorAlert = false
        self.showErrorMessage = false
    }
}

// MARK: - l10n.AuthManagerViewModel

// swiftlint:disable line_length

extension l10n {
    enum AuthManagerViewModel {
        static let unverifiedEmailNotification = LocalizedString("accountkit.auth_manager_view_model.unverified_email_notification",
                                                                 bundle: AccountKitResources.bundle,
                                                                 value: "Your email hasn't been verified yet. Please verify your email to avoid losing your data.",
                                                                 comment: "Unverified email notification message")
    }
}

// swiftlint:enable line_length
