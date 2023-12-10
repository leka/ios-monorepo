// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var credentials = CompanyCredentialsViewModel.shared
    @State private var showErrorAlert = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                self.emailField
                self.resetPasswordButton
            }
            .textInputAutocapitalization(.never)
            .frame(maxWidth: 400)
            .padding(.horizontal)
            .navigationTitle("Reset Password View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .animation(.default, value: self.credentials.isEmailValid())
            .navigationBarItems(trailing: Button("Dismiss", action: { self.dismiss() }))
            .alert("Réinitialiser le mot de passe", isPresented: self.$authManager.showNotificationAlert) {
                // nothing to show
            } message: {
                Text(self.authManager.notificationMessage)
            }
            .alert("An error occurred", isPresented: self.$showErrorAlert) {
                // nothing to show
            } message: {
                Text(self.authManager.errorMessage)
            }
            .onReceive(self.authManager.$showErrorAlert) { newValue in
                self.showErrorAlert = newValue
            }
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: self.$credentials.mail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            if !self.credentials.mail.isEmpty,
               !self.credentials.isEmailValid()
            {
                Text(self.credentials.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var resetPasswordButton: some View {
        Button(
            action: {
                self.authManager.sendPasswordReset(to: self.credentials.mail)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss()
                }
            },
            label: {
                Text("Reset Password")
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .disabled(!self.credentials.isEmailValid())
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthManager())
}
