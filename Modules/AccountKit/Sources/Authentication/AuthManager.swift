// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Firebase
import FirebaseAuthCombineSwift
import Foundation
import LogKit

let log = LogKit.createLoggerFor(module: "AccountKit")

// MARK: - AuthManager

public class AuthManager: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.auth.addStateDidChangeListener { _, user in
            self.emailHasBeenConfirmed = user?.isEmailVerified ?? false
        }
        self.checkAuthenticationStatus()
    }

    // MARK: Public

    public enum FirebaseAuthenticationState {
        case unknown
        case loggedOut
        case loggedIn
    }

    @Published public var userAuthenticationState: FirebaseAuthenticationState = .unknown
    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false
    @Published public var actionRequestMessage: String = ""
    @Published public var showactionRequestAlert = false
    @Published public var notificationMessage: String = ""
    @Published public var showNotificationAlert = false
    @Published public var userIsSigningUp = false

    // Read-only access to properties CurrentUserID and Email to the external classes
    public func currentUserID() -> String? {
        self.auth.currentUser?.uid
    }

    public func currentUserEmail() -> String? {
        self.auth.currentUser?.email
    }

    public func checkAuthenticationStatus() {
        self.auth.publisher(for: \.currentUser)
            .map { [weak self] user in
                self?.updateAuthState(for: user)
                return self?.userAuthenticationState ?? .unknown
            }
            .print()
            .assign(to: &self.$userAuthenticationState)
    }

    public func signIn(email: String, password: String) {
        self.auth.signIn(withEmail: email, password: password)
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                self.handleCompletion(newState: .loggedOut, operation: .signIn),
                receiveValue:
                self.handleUserUpdate(operation: .signIn)
            )
            .store(in: &self.cancellables)
    }

    public func signUp(email: String, password: String) {
        self.auth.createUser(withEmail: email, password: password)
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                self.handleCompletion(newState: .loggedOut, operation: .signUp),
                receiveValue:
                self.handleUserUpdate(operation: .signUp)
            )
            .store(in: &self.cancellables)
    }

    public func sendPasswordReset(to email: String) {
        self.auth.sendPasswordReset(withEmail: email)
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                self.handleCompletion(newState: .unknown, operation: .resetPassword),
                receiveValue: { [weak self] _ in
                    self?.notificationMessage = "An email has been sent to \(email) to reset your password."
                    self?.showNotificationAlert = true
                }
            )
            .store(in: &self.cancellables)
    }

    public func sendEmailVerification() {
        self.auth.currentUser!.sendEmailVerification()
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                self.handleCompletion(newState: .unknown, operation: .confirmEmail),
                receiveValue: { [weak self] _ in
                    self?.notificationMessage = "Verification email sent to your email. Please check your inbox."
                    self?.showNotificationAlert = true
                }
            )
            .store(in: &self.cancellables)
    }

    public func signOut() {
        do {
            try self.auth.signOut()
            self.userAuthenticationState = .loggedOut
            log.notice("Company was successfully signed out. 🙋‍♂️")
        } catch let signOutError {
            errorMessage = signOutError.localizedDescription
        }
    }

    public func deleteAccount() {
        guard let currentUser = auth.currentUser else {
            log.info("No company signed-in currently.")
            return
        }
        currentUser.delete { [weak self] error in
            if let error {
                log.error("Error deleting company: \(error.localizedDescription)")
                self?.errorMessage = "There was an error deleting your account. Please try again later"
            } else {
                self?.userAuthenticationState = .loggedOut
                log.info("Account deleted successfully.")
            }
        }
    }

    // MARK: Internal

    enum FirebaseAuthenticationOperation: String {
        case signIn = "signed in"
        case signUp = "signed up"
        case confirmEmail = "confirm email"
        case resetPassword = "reset password"
        case reauthenticate = "re-authentication"
    }

    // MARK: Private

    private let auth = Auth.auth()
    private var emailHasBeenConfirmed: Bool = false
    private var cancellables = Set<AnyCancellable>()

    private func updateAuthState(for user: User?) {
        self.userAuthenticationState = user != nil ? .loggedIn : .loggedOut
        guard self.emailHasBeenConfirmed else {
            self.actionRequestMessage =
                "Your email hasn't been verified yet. Please verify your email to avoid losing your data."
            self.showactionRequestAlert = true
            return
        }
    }

    // MARK: - Completion & error handling

    private func handleCompletion(newState: FirebaseAuthenticationState, operation: FirebaseAuthenticationOperation)
        -> (Subscribers.Completion<Error>) -> Void
    {
        { [weak self] completion in
            switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.errorMessage = error.localizedDescription
                    self?.handleOperationsErrors(error, operation: operation)
                    self?.userAuthenticationState = newState
            }
        }
    }

    private func handleUserUpdate(operation: FirebaseAuthenticationOperation) -> (AuthDataResult) -> Void {
        { [weak self] result in
            self?.userAuthenticationState = .loggedIn
            log.notice("Company \(result.user.uid) \(operation.rawValue) successfully. 🎉")
            if case .signIn = operation {
                self?.checkAuthenticationStatus()
            }
            if case .signUp = operation {
                self?.userIsSigningUp = true
                self?.sendEmailVerification()
            }
        }
    }

    private func handleOperationsErrors(_: Error, operation: FirebaseAuthenticationOperation) {
        var message = ""
        switch operation {
            case .signIn:
                message = "Sign-in failed. Please try again."
            case .signUp:
                message = "Sign-up failed. Please try again later."
            case .resetPassword:
                message = "There was an error resetting your password. Please try again later."
            case .confirmEmail:
                message = "There was an error sending the verification email. Please try again later."
            case .reauthenticate:
                message = "There was an error authenticating with this password. Please try again."
        }

        self.showErrorAlert(with: message)
    }

    private func showErrorAlert(with message: String) {
        Just(message)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newMessage in
                self?.errorMessage = newMessage
                self?.showErrorAlert = true
            }
            .store(in: &self.cancellables)
    }
}
