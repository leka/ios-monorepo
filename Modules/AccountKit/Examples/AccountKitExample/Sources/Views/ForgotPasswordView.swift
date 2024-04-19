// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ForgotPasswordView: View {
    @State private var organisation = OrganisationViewModel()
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
            .animation(.default, value: self.organisation.isEmailValid())
            .navigationBarItems(trailing: Button("Dismiss", action: { self.dismiss() }))
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: self.$organisation.mail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            if !self.organisation.mail.isEmpty,
               !self.organisation.isEmailValid()
            {
                Text(self.organisation.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var resetPasswordButton: some View {
        Button(
            action: {
                self.dismiss()
            },
            label: {
                Text("Reset Password")
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .disabled(!self.organisation.isEmailValid())
    }
}

#Preview {
    ForgotPasswordView()
}
