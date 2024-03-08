// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

    @Binding var isCaregiverPickerPresented: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button {
                        self.rootOwnerViewModel.isSettingsViewPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.isCaregiverPickerPresented = true
                        }
                    } label: {
                        Label(String(l10n.SettingsView.ProfilesSection.switchProfileButtonLabel.characters), systemImage: "person.2.gobackward")
                    }
                }

                Section {
                    Button(String(l10n.SettingsView.ChangeLanguageSection.buttonLabel.characters), systemImage: "globe") {
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        self.openURL(settingsURL)
                    }
                }

                Section {
                    LabeledContent {
                        Text(self.authManager.currentUserEmail ?? "")
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Color.secondary)
                    } label: {
                        Text(l10n.SettingsView.CredentialsSection.emailLabel)
                    }
                } footer: {
                    Button {
                        self.rootOwnerViewModel.showConfirmCredentialsChange = true
                    } label: {
                        HStack {
                            Spacer()
                            Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.buttonLabel)
                                .font(.footnote)
                        }
                    }
                    .alert(String(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertTitle.characters),
                           isPresented: self.$rootOwnerViewModel.showConfirmCredentialsChange) {} message: {
                        Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertMessage)
                    }
                }

                Section {
                    Button {
                        self.rootOwnerViewModel.showConfirmDisconnection = true
                    } label: {
                        Label(String(l10n.SettingsView.AccountSection.LogOut.buttonLabel.characters),
                              systemImage: "rectangle.portrait.and.arrow.forward")
                    }
                    .alert(String(l10n.SettingsView.AccountSection.LogOut.alertTitle.characters),
                           isPresented: self.$rootOwnerViewModel.showConfirmDisconnection)
                    {
                        Button(role: .destructive) {
                            self.rootOwnerViewModel.isSettingsViewPresented = false
                            self.authManager.signOut()
                            self.reset()
                        } label: {
                            Text(l10n.SettingsView.AccountSection.LogOut.alertButtonLabel)
                        }
                    } message: {
                        Text(l10n.SettingsView.AccountSection.LogOut.alertMessage)
                    }
                    .alert(String(l10n.SettingsView.AccountSection.LogOut.errorAlertTitle.characters),
                           isPresented: self.$authManagerViewModel.showErrorAlert)
                    {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(l10n.SettingsView.AccountSection.LogOut.errorAlertMessage)
                    }

                    Button(role: .destructive) {
                        self.rootOwnerViewModel.showConfirmDeleteAccount = true
                    } label: {
                        Label(String(l10n.SettingsView.AccountSection.DeleteAccount.buttonLabel.characters), systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                    .alert(String(l10n.SettingsView.AccountSection.DeleteAccount.alertTitle.characters),
                           isPresented: self.$rootOwnerViewModel.showConfirmDeleteAccount)
                    {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(l10n.SettingsView.AccountSection.DeleteAccount.alertMessage)
                    }
                }
            }
            .navigationTitle(String(l10n.SettingsView.navigationTitle.characters))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String(l10n.SettingsView.closeButtonLabel.characters)) {
                        self.rootOwnerViewModel.isSettingsViewPresented = false
                    }
                }
            }
        }
        .preferredColorScheme(self.styleManager.colorScheme)
    }

    private let authManager = AuthManager.shared
    private let caregiverManager: CaregiverManager = .shared
    private let carereceiverManager: CarereceiverManager = .shared

    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    private func reset() {
        self.caregiverManager.resetData()
        self.carereceiverManager.resetData()
        self.styleManager.accentColor = DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
        self.styleManager.colorScheme = .light
    }
}

#Preview {
    Text("Hello, World!")
        .sheet(isPresented: .constant(true)) {
            SettingsView(isCaregiverPickerPresented: .constant(false))
        }
}
