// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Firebase
import FirebaseAuthCombineSwift
import Foundation

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
    @Published public var isWelcomeViewPresented = false
    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert = false
    @Published public var actionRequestMessage: String = ""
    @Published public var showActionRequestAlert = false
    @Published public var notificationMessage: String = ""
    @Published public var showNotificationAlert = false
    @Published public var userIsSigningUp = false

    public func checkAuthenticationStatus() {
        self.auth.publisher(for: \.currentUser)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.updateAuthState(for: user)
                guard user != nil else {
                    self?.userAuthenticationState = .loggedOut
                    self?.isWelcomeViewPresented = true
                    return
                }
                self?.userAuthenticationState = .loggedIn
                self?.isWelcomeViewPresented = false
            }
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
//            self.isWelcomeViewPresented = true
            log.notice("Company was successfully signed out. 🙋‍♂️")
        } catch let signOutError {
            errorMessage = signOutError.localizedDescription
        }
    }

    // MARK: Internal

    enum FirebaseAuthenticationOperation: String {
        case signUp = "signed up"
        case confirmEmail = "confirm email"
    }

    // MARK: Private

    private let auth = Auth.auth()
    private var emailHasBeenConfirmed: Bool = false
    private var cancellables = Set<AnyCancellable>()

    private func updateAuthState(for user: User?) {
        let newState = user != nil ? FirebaseAuthenticationState.loggedIn : .loggedOut
        self.userAuthenticationState = newState
        guard self.emailHasBeenConfirmed else {
            self.actionRequestMessage =
                "Your email hasn't been verified yet. Please verify your email to avoid losing your data."
            self.showActionRequestAlert = true
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
            if case .signUp = operation {
                self?.userIsSigningUp = true
                self?.sendEmailVerification()
                self?.isWelcomeViewPresented = false // temp
            }
        }
    }

    private func handleOperationsErrors(_: Error, operation: FirebaseAuthenticationOperation) {
        var message = ""
        switch operation {
            case .signUp:
                message = "Sign-up failed. Please try again later."
            case .confirmEmail:
                message = "There was an error sending the verification email. Please try again later."
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
