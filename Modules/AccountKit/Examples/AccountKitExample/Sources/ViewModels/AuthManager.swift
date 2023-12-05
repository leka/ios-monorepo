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
        case resetPassword = "reset password"
        case confirmEmail = "confirm email"
    }

    @Published private(set) var companyAuthenticationState: FirebaseAuthenticationState = .unknown
    @Published private var emailHasBeenConfirmed: Bool = false
    @Published var errorMessage: String = ""
    @Published var showErrorMessageAlert = false

    private let auth = Auth.auth()
    private var cancellables = Set<AnyCancellable>()

    init() {
        checkAuthenticationStatus()
        auth.addStateDidChangeListener { _, user in
            self.emailHasBeenConfirmed = user?.isEmailVerified ?? false
        }
    }

    private func updateAuthState(for company: User?) {
        companyAuthenticationState = company != nil ? .loggedIn : .loggedOut
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
            .sink { [weak self] completion in
                self?.handleCompletion(completion, newState: .loggedOut, operation: .signIn)
            } receiveValue: { [weak self] result in
                self?.handleUserUpdate(result: result, operation: .signIn)
            }
            .store(in: &cancellables)
    }

    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, newState: .loggedOut, operation: .signUp)
            } receiveValue: { [weak self] result in
                self?.handleUserUpdate(result: result, operation: .signUp)
            }
            .store(in: &cancellables)
    }

    func sendPasswordReset(with email: String) {
        auth.sendPasswordReset(withEmail: email)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, newState: .unknown, operation: .resetPassword)
            } receiveValue: { _ in
                // nothing to do
            }
            .store(in: &cancellables)
    }

    // TODO(@macteuts): Handle user notification/alert
    func sendEmailVerification(for user: User) {
        user.sendEmailVerification()
            .sink { [weak self] completion in
                self?.handleCompletion(completion, newState: .unknown, operation: .confirmEmail)
            } receiveValue: { _ in
                print("Verification email sent to \(user.email ?? "your email"). Please check your inbox.")
            }
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

    // TODO(@macteuts): Handle user notification/alert
    func deleteAccount() {
        guard let currentUser = auth.currentUser else {
            print("No company signed-in currently.")
            return
        }
        currentUser.delete { [weak self] error in
            if let error = error {
                print("Error deleting company: \(error.localizedDescription)")
            } else {
                self?.companyAuthenticationState = .loggedOut
                print("Account deleted successfully.")
            }
        }
    }

    // MARK: - Completion & error handling
    private func handleCompletion(
        _ completion: Subscribers.Completion<Error>,
        newState: FirebaseAuthenticationState,
        operation: FirebaseAuthenticationOperation
    ) {
        switch completion {
            case .finished:
                break
            case .failure(let error):
                errorMessage = error.localizedDescription
                handleOperationsErrors(error, operation: operation)
                companyAuthenticationState = newState
        }
    }

    // TODO(@macteuts): Handle user notification/alert + navigation
    // TODO(@macteuts): Add "Send again" button
    private func handleUserUpdate(result: AuthDataResult, operation: FirebaseAuthenticationOperation) {
        guard result.user.isEmailVerified else {
            switch operation {
                case .resetPassword:
                    // show alert
                    // navigate back to signIn
                    print("An email has been sent to \(result.user.email ?? "your email") to reset your password.")
                default:
                    // Show alert asking to verifiy email + resend button
                    // signUp: navigate back to signIn
                    // signIn: login automatically??
                    print("Verification email sent to \(result.user.email ?? "your email"). Please check your inbox.")
                    sendEmailVerification(for: result.user)
            }
            return
        }
        companyAuthenticationState = .loggedIn
        print("Company \(result.user.uid) \(operation.rawValue) successfully.")
    }

    private func handleOperationsErrors(_ error: Error, operation: FirebaseAuthenticationOperation) {
        switch operation {
            case .signIn:
                errorMessage = "Sign-in failed. Please try again."
            case .signUp:
                errorMessage = "Sign-up failed. Please try again later."
            case .resetPassword:
                errorMessage = "There was an error resetting your password. Please try again later."
            case .confirmEmail:
                errorMessage = "There was an error sending the verification email. Please try again later."
        }
    }
}
