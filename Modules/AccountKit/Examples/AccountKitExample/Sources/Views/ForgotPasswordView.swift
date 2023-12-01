// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ForgotPasswordView: View {

    @EnvironmentObject var authManager: AuthManager
    @State private var credentials = CompanyCredentialsViewModel()
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
            .animation(.default, value: credentials.isEmailValid())
            .navigationBarItems(trailing: Button("Dismiss", action: { dismiss() }))
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: $credentials.mail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            if !credentials.mail.isEmpty
                && !credentials.isEmailValid()
            {
                Text(credentials.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var resetPasswordButton: some View {
        Button(
            action: {
                authManager.sendPasswordReset(with: credentials.mail)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dismiss()
                }
            },
            label: {
                Text("Reset Password")
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .disabled(!credentials.isEmailValid())
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthManager())
}
