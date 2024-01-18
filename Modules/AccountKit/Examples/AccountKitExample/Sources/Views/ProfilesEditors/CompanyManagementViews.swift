// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import SwiftUI

// MARK: - Company Views

struct EditCompanyView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var profilesVM: ProfilesViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 20) {
                GroupBox("Edit Company Name") {
                    TextField("Name", text: self.$profilesVM.currentCompany.name)
                        .padding(.top, 10)
                }
                .textFieldStyle(.roundedBorder)
                .onAppear {
                    self.profilesVM.fetchCurrentCompanyDetails()
                }

                HStack(spacing: 10) {
                    Button {
                        self.profilesVM.updateCompany()
                    } label: {
                        Label("Save Changes", systemImage: "person.crop.circle.badge.checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    Button {
                        self.showDeleteConfirmation.toggle()
                    } label: {
                        Label("Delete Company", systemImage: "trash")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()

            if self.profilesVM.isUpdating {
                Color.black.opacity(0.15).ignoresSafeArea()
                ProgressView()
            }
        }
        .ignoresSafeArea()
        .alert("Supprimer le compte", isPresented: self.$showDeleteConfirmation) {
            Button(role: .destructive) {
                // re-auth + delete company/CG/CR and then only deleteAccount
                self.authManager.deleteAccount()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss()
                }
            } label: {
                Text("Supprimer")
            }
        } message: {
            Text(
                "Vous êtes sur le point de supprimer le compte de votre établissemnt. \nCette action est irreversible."
            )
        }
    }

    // MARK: Private

    @State private var showDeleteConfirmation: Bool = false
}
