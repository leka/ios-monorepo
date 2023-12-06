// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ForgotPasswordView: View {
    @State private var organisation = OrganisationViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                emailField
                resetPasswordButton
            }
            .textInputAutocapitalization(.never)
            .frame(maxWidth: 400)
            .padding(.horizontal)
            .navigationTitle("Reset Password View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .animation(.default, value: organisation.isEmailValid())
            .navigationBarItems(trailing: Button("Dismiss", action: { dismiss() }))
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: $organisation.mail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            if !organisation.mail.isEmpty,
                !organisation.isEmailValid()
            {
                Text(organisation.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var resetPasswordButton: some View {
        Button(
            action: {
                dismiss()
            },
            label: {
                Text("Reset Password")
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .disabled(!organisation.isEmailValid())
    }
}

#Preview {
    ForgotPasswordView()
}
