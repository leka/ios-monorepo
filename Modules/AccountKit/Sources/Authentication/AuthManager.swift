// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift
import Foundation

public class AuthManager {
    // MARK: Lifecycle

    private init() {
        _ = self.auth.addStateDidChangeListener { [weak self] _, user in
            self?.updateAuthState(for: user)
        }
    }

    // MARK: Public

    public enum AuthenticationState {
        case unknown
        case loggedOut
        case loggedIn
    }

    public enum UserAction {
        case userIsSigningUp
        case userIsSigningIn
        case userIsSigningOut
        case userIsReAuthenticating
        case userIsResettingPassword
        case userIsDeletingAccount
    }

    public static let shared = AuthManager()

    public var currentUserEmail: String? {
        self.auth.currentUser?.email
    }

    public var authenticationStatePublisher: AnyPublisher<AuthenticationState, Never> {
        self.authenticationState.eraseToAnyPublisher()
    }

    public func signUp(email: String, password: String) {
        self.loadingStatePublisher.send(true)
        self.auth.createUser(withEmail: email, password: password)
            .mapError { $0 as Error }
            .sink(receiveCompletion: { [weak self] completion in
                self?.loadingStatePublisher.send(false)
                switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        log.error("\(error.localizedDescription)")
                        self?.authenticationError.send(error)
                }
            }, receiveValue: { [weak self] result in
                log.info("User \(result.user.uid) signed-up successfully. 🎉")
                self?.authenticationState.send(.loggedIn)
                self?.sendEmailVerification()
            })
            .store(in: &self.cancellables)
    }

    public func signIn(email: String, password: String) {
        self.loadingStatePublisher.send(true)
        self.auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            self?.loadingStatePublisher.send(false)
            if let error {
                log.error("Sign-in failed: \(error.localizedDescription)")
                self?.authenticationError.send(error)
            } else if let user = authResult?.user {
                log.info("User \(user.uid) signed-in successfully. 🎉")
                self?.authenticationState.send(.loggedIn)
                self?.emailVerificationState.send(user.isEmailVerified)
            }
        }
    }

    public func signOut() {
        do {
            try self.auth.signOut()
            self.authenticationState.send(.loggedOut)
            log.info("User was successfully signed out.")
        } catch {
            log.error("Sign out failed: \(error.localizedDescription)")
            self.authenticationError.send(error)
        }
    }

    public func sendEmailVerification() {
        guard let currentUser = auth.currentUser else { return }
        currentUser.sendEmailVerification { [weak self] error in
            if let error {
                log.error("\(error.localizedDescription)")
                self?.authenticationError.send(error)
                return
            }
        }
    }

    public func reAuthenticateCurrentUser(password: String) {
        guard let email = self.currentUserEmail else {
            let errorMessage = "Reauthentication failed: No email found for the current user."
            log.error("\(errorMessage)")
            self.authenticationError.send(AuthenticationError.custom(message: errorMessage))
            return
        }

        self.loadingStatePublisher.send(true)
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        self.auth.currentUser?.reauthenticate(with: credential) { [weak self] _, error in
            self?.loadingStatePublisher.send(false)
            if let error {
                log.error("Reauthentication failed: \(error.localizedDescription)")
                self?.authenticationError.send(error)
                self?.reAuthenticationState.send(false)
            } else {
                log.info("Reauthentication was successful. 🎉")
                self?.reAuthenticationState.send(true)
            }
        }
    }

    public func sendPasswordResetEmail(to email: String) {
        self.loadingStatePublisher.send(true)
        self.auth.sendPasswordReset(withEmail: email) { [weak self] error in
            self?.loadingStatePublisher.send(false)
            if let error {
                log.error("Failed to send password reset email: \(error.localizedDescription)")
                self?.authenticationError.send(error)
                self?.passwordResetEmail.send(false)
            } else {
                log.info("Password reset email sent successfully.")
                self?.passwordResetEmail.send(true)
            }
        }
    }

    public func deleteCurrentUser() {
        self.auth.currentUser?.delete { [weak self] error in
            if let error {
                log.error("Account deletion failed: \(error.localizedDescription)")
                self?.authenticationError.send(error)
            } else {
                log.info("Account deleted successfully.")
                self?.authenticationState.send(.loggedOut)
            }
        }
    }

    // MARK: Internal

    var authenticationErrorPublisher: AnyPublisher<Error, Never> {
        self.authenticationError.eraseToAnyPublisher()
    }

    var emailVerificationStatePublisher: AnyPublisher<Bool, Never> {
        self.emailVerificationState.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        self.loadingStatePublisher.eraseToAnyPublisher()
    }

    var reAuthenticationStatePublisher: AnyPublisher<Bool, Never> {
        self.reAuthenticationState.eraseToAnyPublisher()
    }

    var passwordResetEmailPublisher: AnyPublisher<Bool, Never> {
        self.passwordResetEmail.eraseToAnyPublisher()
    }

    // MARK: Private

    private let authenticationState = CurrentValueSubject<AuthenticationState, Never>(.unknown)
    private let authenticationError = PassthroughSubject<Error, Never>()
    private let loadingStatePublisher = PassthroughSubject<Bool, Never>()
    private let emailVerificationState = PassthroughSubject<Bool, Never>()
    private let reAuthenticationState = PassthroughSubject<Bool, Never>()
    private let passwordResetEmail = PassthroughSubject<Bool, Never>()
    private let auth = Auth.auth()
    private var cancellables = Set<AnyCancellable>()

    private func updateAuthState(for user: User?) {
        guard let user else {
            self.authenticationState.send(.loggedOut)
            return
        }
        self.authenticationState.send(.loggedIn)
        self.emailVerificationState.send(user.isEmailVerified)
    }
}
