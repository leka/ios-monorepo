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
            if case .appUpdateAvailable = UpdateManager.shared.appUpdateStatus {
                Section {
                    VStack(alignment: .center) {
                        HStack(spacing: 20) {
                            LekaAppAsset.Assets.lekaLogoStripes.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            Text(l10n.SettingsView.AppUpdateSection.title)
                                .font(.title2.bold())
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)

                            Text("🎉")
                                .font(.title2)
                        }

                        Button {
                            if let url = URL(string: "https://apps.apple.com/app/leka/id6446940339") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text(l10n.SettingsView.AppUpdateSection.buttonLabel)
                                .frame(maxWidth: 300)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

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
                    Button(String(l10n.SettingsView.CredentialsSection.ChangeCredentials.buttonLabel.characters), systemImage: "lock") {
                        self.showConfirmCredentialsChange = true
                    }
                    .alert(String(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertTitle.characters),
                           isPresented: self.$showConfirmCredentialsChange)
                    {
                        Button(role: .destructive) {
                            self.authManager.sendPasswordResetEmail(to: self.authManager.currentUserEmail ?? "")
                            self.authManagerViewModel.userAction = .userIsResettingPassword
                            self.showConfirmCredentialsChange = false
                        } label: {
                            Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertChangePasswordButtonLabel)
                        }

                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.alertMessage)
                    }
                    .alert(String(l10n.SettingsView.CredentialsSection.ChangeCredentials.changePasswordSuccessAlertTitle.characters),
                           isPresented: self.$authManagerViewModel.resetPasswordSucceeded)
                    {
                        Button("OK", role: .cancel) {
                            self.authManagerViewModel.userAction = .none
                        }
                    } message: {
                        Text(l10n.SettingsView.CredentialsSection.ChangeCredentials.changePasswordSuccessAlertMessage)
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
                        guard self.authManagerViewModel.reAuthenticationSucceeded else {
                            if self.authManagerViewModel.userAction == .userIsReAuthenticating {
                                self.authManagerViewModel.userAction = .none
                            }
                            return
                        }
                        self.showConfirmDeleteAccount = true
                    } content: {
                        ReAuthenticationView()
                    }
                    .alert(String(l10n.SettingsView.AccountSection.DeleteAccount.alertTitle.characters),
                           isPresented: self.$showConfirmDeleteAccount)
                    {
                        Button(
                            String(l10n.SettingsView.AccountSection.DeleteAccount.alertCancelButtonLabel.characters),
                            role: .cancel
                        ) {
                            self.authManagerViewModel.userAction = .none
                        }
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

            #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                Section {
                    Toggle("Demo Mode", isOn: self.$navigation.demoMode)
                } header: {
                    Text("Developer / TestFlight Options")
                }
            #endif

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
            Button("OK", role: .cancel) {
                self.authManagerViewModel.userAction = .none
            }
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
        .onDisappear {
            self.authManagerViewModel.resetErrorMessage()
        }
    }

    private let authManager = AuthManager.shared
    private let caregiverManager: CaregiverManager = .shared
    private let carereceiverManager: CarereceiverManager = .shared
    private var libraryManager: LibraryManager = .shared
    private let persistentDataManager: PersistentDataManager = .shared
    private var styleManager: StyleManager = .shared

    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @ObservedObject private var navigation = Navigation.shared

    private func reset() {
        self.caregiverManager.resetData()
        self.carereceiverManager.resetData()
        self.libraryManager.resetData()
        self.styleManager.setAccentColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        self.styleManager.setColorScheme(.light)
    }

    private var errorAlertTitle: String {
        switch self.authManagerViewModel.userAction {
            case .userIsDeletingAccount:
                String(l10n.SettingsView.AccountSection.DeleteAccount.errorAlertTitle.characters)
            case .userIsResettingPassword:
                String(l10n.SettingsView.CredentialsSection.ChangeCredentials.errorAlertTitle.characters)
            default:
                String(l10n.SettingsView.AccountSection.LogOut.errorAlertTitle.characters)
        }
    }

    private var errorAlertMessage: String {
        switch self.authManagerViewModel.userAction {
            case .userIsDeletingAccount:
                String(l10n.SettingsView.AccountSection.DeleteAccount.errorAlertMessage.characters)
            case .userIsResettingPassword:
                String(l10n.SettingsView.CredentialsSection.ChangeCredentials.errorAlertMessage.characters)
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
