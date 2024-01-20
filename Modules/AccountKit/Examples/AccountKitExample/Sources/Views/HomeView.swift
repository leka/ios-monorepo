// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import SwiftUI

struct HomeView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        switch self.authManager.userAuthenticationState {
            case .unknown:
                Text("Loading...")
            case .loggedIn:
                NavigationStack {
                    self.content
                }
            case .loggedOut:
                AuthenticationView()
        }
    }

    // MARK: Private

    @State private var goBackToContentView: Bool = false
    @State private var showErrorAlert = false
    @StateObject private var profilesVM = ProfilesViewModel(userUID: "")

    private var content: some View {
        VStack(spacing: 10) {
            Text("Company \(self.profilesVM.currentCompany.name) is Logged In!")
                .fontWeight(.heavy)
            Text("Connection email: \(self.profilesVM.currentCompany.email)")
                .font(.footnote)
                .opacity(0.7)

            Button(
                action: {
                    self.authManager.signOut()
                },
                label: {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.bordered)
            .frame(maxWidth: 200)
        }
        .padding()
        .onAppear {
            if let userID = authManager.currentUserID() {
                self.profilesVM.userUID = userID
                self.handleAuthenticationResult(userID: userID)
            }
            self.profilesVM.testCompany(withID: "SMKZUYHSZ82zuWwVz3Wr") // macteuts
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        self.profilesVM.showEditCompany.toggle()
                    } label: {
                        Label("Edit Company", systemImage: "building.2.crop.circle")
                    }
                    Divider()
                    Button {
                        self.profilesVM.showCreateCaregiver.toggle()
                    } label: {
                        Label("New Caregiver", systemImage: "person.crop.circle.badge.plus")
                    }
                    Button {
                        self.profilesVM.showEditCaregivers.toggle()
                    } label: {
                        Label("Edit Caregivers", systemImage: "person.2.crop.square.stack")
                    }
                    Divider()
                    Button {
                        self.profilesVM.showCreateCarereceiver.toggle()
                    } label: {
                        Label("New Carereceiver", systemImage: "person.crop.circle.badge.plus")
                    }
                    Button {
                        self.profilesVM.showEditCarereceivers.toggle()
                    } label: {
                        Label("Edit Carereceivers", systemImage: "person.2.crop.square.stack")
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .padding(20)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        })
        .sheet(isPresented: self.$profilesVM.showEditCompany) {
            EditCompanyView(profilesVM: self.profilesVM)
        }
        .sheet(isPresented: self.$profilesVM.showCreateCaregiver) {
            CreateCaregiverView(profilesVM: self.profilesVM)
        }
        .sheet(isPresented: self.$profilesVM.showEditCaregivers) {
            CaregiversListView(profilesVM: self.profilesVM)
        }
        .sheet(isPresented: self.$profilesVM.showCreateCarereceiver) {
            CreateCarereceiverView(profilesVM: self.profilesVM)
        }
        .sheet(isPresented: self.$profilesVM.showEditCarereceivers) {
            CarereceiversListView(profilesVM: self.profilesVM)
        }
        .alert("Email non-vérifié", isPresented: self.$authManager.showactionRequestAlert) {
            Button(role: .none) {
                self.authManager.sendEmailVerification()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss()
                }
            } label: {
                Text("Renvoyer")
            }
            Button(role: .cancel) {
                self.dismiss()
            } label: {
                Text("Plus tard")
            }
        } message: {
            Text(self.authManager.actionRequestMessage)
        }
        .alert("Vérification de votre email", isPresented: self.$authManager.showNotificationAlert) {
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

    // temporary, due to the current architecture
    private func handleAuthenticationResult(userID: String) {
        if self.authManager.userIsSigningUp {
            self.profilesVM.createCompanyDocument()
            self.authManager.userIsSigningUp.toggle()
        } else {
            self.profilesVM.fetchCompanyByOwnerUID(ownerUID: userID)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
