// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import DeviceKit
import LocalizationKit
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) var dismiss

    @State private var showConfirmCredentialsChange: Bool = false
    @State private var showConfirmDisconnection: Bool = false
    @State private var showConfirmDeleteAccount: Bool = false
    @State private var showReAuthenticate: Bool = false
    @State private var isCaregiverpickerPresented: Bool = false

    var body: some View {
        Form {
            if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                Section {
                    Button {
                        self.isCaregiverpickerPresented = true
                    } label: {
                        Label(String(l10n.SettingsView.ProfilesSection.buttonLabel.characters), systemImage: "person.2.gobackward")
                    }
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

            if self.authManagerViewModel.userAuthenticationState == .loggedIn {
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
                        self.showConfirmCredentialsChange = true
                    } label: {
                        HStack {
                            Spacer()
                            Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.buttonLabel)
                                .font(.footnote)
                        }
                    }
                    .alert(String(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertTitle.characters),
                           isPresented: self.$showConfirmCredentialsChange) {} message: {
                        Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertMessage)
                    }
                }
            }

            Section {
                if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                    Button {
                        self.showConfirmDisconnection = true
                        self.authManagerViewModel.userAction = .userIsSigningOut
                    } label: {
                        Label(String(l10n.SettingsView.AccountSection.LogOut.buttonLabel.characters),
                              systemImage: "rectangle.portrait.and.arrow.forward")
                    }
                    .alert(String(l10n.SettingsView.AccountSection.LogOut.alertTitle.characters),
                           isPresented: self.$showConfirmDisconnection)
                    {
                        Button(role: .destructive) {
                            self.dismiss()
                            self.authManager.signOut()
                            self.persistentDataManager.clearUserData()
                            self.reset()
                        } label: {
                            Text(l10n.SettingsView.AccountSection.LogOut.alertButtonLabel)
                        }
                    } message: {
                        Text(l10n.SettingsView.AccountSection.LogOut.alertMessage)
                    }

                    Button(role: .destructive) {
                        self.showReAuthenticate = true
                        self.authManagerViewModel.userAction = .userIsReAuthenticating
                    } label: {
                        Label(String(l10n.SettingsView.AccountSection.DeleteAccount.buttonLabel.characters), systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                    .sheet(isPresented: self.$showReAuthenticate) {
                        if self.authManagerViewModel.reAuthenticationSucceeded {
                            self.showConfirmDeleteAccount = true
                        } else {
                            self.authManagerViewModel.userAction = .none
                        }
                    } content: {
                        ReAuthenticationView()
                    }
                    .alert(String(l10n.SettingsView.AccountSection.DeleteAccount.alertTitle.characters),
                           isPresented: self.$showConfirmDeleteAccount)
                    {
                        Button(
                            String(l10n.SettingsView.AccountSection.DeleteAccount.alertCancelButtonLabel.characters),
                            role: .cancel
                        ) {}
                        Button(
                            String(l10n.SettingsView.AccountSection.DeleteAccount.alertDeleteButtonLabel.characters),
                            role: .destructive
                        ) {
                            self.dismiss()
                            self.authManager.deleteCurrentUser()
                        }
                    } message: {
                        Text(l10n.SettingsView.AccountSection.DeleteAccount.alertMessage)
                    }
                } else {
                    Button(String(l10n.SettingsView.AccountSection.LogInSignUp.buttonLabel.characters), systemImage: "person.fill") {
                        self.dismiss()
                        self.authManagerViewModel.userAction = .userIsSigningIn
                        self.navigation.fullScreenCoverContent = .welcomeView
                    }
                }
            }

            Section("Support") {
                LabeledContent("Version", value: Bundle.version!)
                    .font(.footnote)
                LabeledContent("Build Number", value: Bundle.buildNumber!)
                    .font(.footnote)
                LabeledContent("iPad Model", value: Device.current.description)
                    .font(.footnote)
                LabeledContent("iOS Version", value: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
                    .font(.footnote)
            }
        }
        .onReceive(self.authManagerViewModel.$userAuthenticationState, perform: { newState in
            if newState == .loggedOut {
                self.persistentDataManager.clearUserData()
                self.reset()
            }
        })
        .navigationTitle(String(l10n.SettingsView.navigationTitle.characters))
        .sheet(isPresented: self.$isCaregiverpickerPresented) {
            NavigationStack {
                CaregiverPicker()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert(self.errorAlertTitle,
               isPresented: self.$authManagerViewModel.showErrorAlert)
        {
            Button("OK", role: .cancel) {}
        } message: {
            Text(self.errorAlertMessage)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(l10n.SettingsView.closeButtonLabel.characters)) {
                    self.dismiss()
                }
            }
        }
        .preferredColorScheme(self.styleManager.colorScheme)
    }

    private let authManager = AuthManager.shared
    private let caregiverManager: CaregiverManager = .shared
    private let carereceiverManager: CarereceiverManager = .shared
    private let persistentDataManager: PersistentDataManager = .shared

    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var navigation = Navigation.shared

    private func reset() {
        self.caregiverManager.resetData()
        self.carereceiverManager.resetData()
        self.styleManager.accentColor = DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
        self.styleManager.colorScheme = .light
    }

    private var errorAlertTitle: String {
        switch self.authManagerViewModel.userAction {
            case .userIsDeletingAccount:
                String(l10n.SettingsView.AccountSection.DeleteAccount.errorAlertTitle.characters)
            default:
                String(l10n.SettingsView.AccountSection.LogOut.errorAlertTitle.characters)
        }
    }

    private var errorAlertMessage: String {
        switch self.authManagerViewModel.userAction {
            case .userIsDeletingAccount:
                String(l10n.SettingsView.AccountSection.DeleteAccount.errorAlertMessage.characters)
            default:
                String(l10n.SettingsView.AccountSection.LogOut.errorAlertMessage.characters)
        }
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                SettingsView()
            }
        }
}
