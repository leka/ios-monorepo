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

    @Published private(set) var companyAuthenticationState: FirebaseAuthenticationState = .unknown
    @Published private var errorMessage: String = ""

    private let auth = Auth.auth()
    private var cancellables = Set<AnyCancellable>()

    init() {
        checkAuthenticationStatus()
    }

    private func handleCompletion(_ completion: Subscribers.Completion<Error>, newState: FirebaseAuthenticationState) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
            print(errorMessage)
            companyAuthenticationState = newState
        }
    }

    private func handleUserUpdate(result: AuthDataResult, operation: String) {
        companyAuthenticationState = .loggedIn
        let company = result.user
        print("Company \(company.uid) \(operation) successfully.")
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
                self?.handleCompletion(completion, newState: .loggedOut)
            } receiveValue: { [weak self] result in
                self?.handleUserUpdate(result: result, operation: "signed in")
            }
            .store(in: &cancellables)
    }

    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, newState: .loggedOut)
            } receiveValue: { [weak self] result in
                self?.handleUserUpdate(result: result, operation: "signed up")
            }
            .store(in: &cancellables)
    }

    func sendPasswordReset(with email: String) {
        auth.sendPasswordReset(withEmail: email)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, newState: .unknown)
            } receiveValue: { _ in
                // nothing to do
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
}


