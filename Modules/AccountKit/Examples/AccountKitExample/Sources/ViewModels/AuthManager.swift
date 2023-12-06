// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Firebase
import FirebaseAuthCombineSwift
import Foundation

class AuthManager: ObservableObject {
    enum FirebaseAuthenticationState {
        case unknown, loggedOut, loggedIn
    }

    enum FirebaseAuthenticationOperation: String {
        case signIn = "signed in"
        case signUp = "signed up"
        case confirmEmail = "confirm email"
        case resetPassword = "reset password"
    }

    @Published private(set) var companyAuthenticationState: FirebaseAuthenticationState = .unknown
    @Published private var emailHasBeenConfirmed: Bool = false

    @Published var errorMessage: String = ""
    @Published var showErrorAlert = false
    @Published var actionRequestMessage: String = ""
    @Published var showactionRequestAlert = false
    @Published var notificationMessage: String = ""
    @Published var showNotificationAlert = false

    private let auth = Auth.auth()
    private var cancellables = Set<AnyCancellable>()

    init() {
        auth.addStateDidChangeListener { _, user in
            self.emailHasBeenConfirmed = user?.isEmailVerified ?? false
        }
        checkAuthenticationStatus()
    }

    private func updateAuthState(for company: User?) {
        companyAuthenticationState = company != nil ? .loggedIn : .loggedOut
        guard emailHasBeenConfirmed else {
            actionRequestMessage =
                "Your email hasn't been verified yet. Please verify your email to avoid losing your data."
            showactionRequestAlert = true
            return
        }
    }

    func checkAuthenticationStatus() {
        auth.publisher(for: \.currentUser)
            .map { [weak self] company in
                self?.updateAuthState(for: company)
                return self?.companyAuthenticationState ?? .unknown
            }
            .print()
            .assign(to: &$companyAuthenticationState)
    }

    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password)
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                    handleCompletion(newState: .loggedOut, operation: .signIn),
                receiveValue:
                    handleUserUpdate(operation: .signIn)
            )
            .store(in: &cancellables)
    }

    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password)
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                    handleCompletion(newState: .loggedOut, operation: .signUp),
                receiveValue:
                    handleUserUpdate(operation: .signUp)
            )
            .store(in: &cancellables)
    }

    func sendPasswordReset(to email: String) {
        auth.sendPasswordReset(withEmail: email)
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                    handleCompletion(newState: .unknown, operation: .resetPassword),
                receiveValue: { [weak self] _ in
                    self?.notificationMessage = "An email has been sent to \(email) to reset your password."
                    self?.showNotificationAlert = true
                }
            )
            .store(in: &cancellables)
    }

    func sendEmailVerification() {
        auth.currentUser!.sendEmailVerification()
            .mapError { $0 as Error }
            .sink(
                receiveCompletion:
                    handleCompletion(newState: .unknown, operation: .confirmEmail),
                receiveValue: { [weak self] _ in
                    self?.notificationMessage = "Verification email sent to your email. Please check your inbox."
                    self?.showNotificationAlert = true
                }
            )
            .store(in: &cancellables)
    }

    func signOut() {
        do {
            try auth.signOut()
            companyAuthenticationState = .loggedOut
            print("Company was successfully signed out.")
        } catch let signOutError {
            errorMessage = signOutError.localizedDescription
        }
    }

    func deleteAccount() {
        guard let currentUser = auth.currentUser else {
            print("No company signed-in currently.")
            return
        }
        currentUser.delete { [weak self] error in
            if let error = error {
                print("Error deleting company: \(error.localizedDescription)")
                self?.errorMessage = "There was an error deleting your account. Please try again later"
            } else {
                self?.companyAuthenticationState = .loggedOut
                print("Account deleted successfully.")
            }
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
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.handleOperationsErrors(error, operation: operation)
                    self?.companyAuthenticationState = newState
            }
        }
    }

    private func handleUserUpdate(operation: FirebaseAuthenticationOperation) -> (AuthDataResult) -> Void {
        { [weak self] result in
            self?.companyAuthenticationState = .loggedIn
            print("Company \(result.user.uid) \(operation.rawValue) successfully.")
            self?.checkAuthenticationStatus()
            if case .signUp = operation {
                self?.sendEmailVerification()
            }
        }
    }

    private func handleOperationsErrors(_ error: Error, operation: FirebaseAuthenticationOperation) {
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
        }

        showErrorAlert(with: message)
    }

    private func showErrorAlert(with message: String) {
        Just(message)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newMessage in
                self?.errorMessage = newMessage
                self?.showErrorAlert = true
            }
            .store(in: &cancellables)
    }
}
