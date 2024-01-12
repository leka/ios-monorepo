// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ProfileSet_Teachers: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel

    var body: some View {
        VStack(spacing: 0) {
            self.header

            // Separator
            Rectangle()
                .fill(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .frame(height: 1)
                .frame(maxWidth: self.navigationVM.showProfileEditor ? .infinity : 460)

            // Avatars
            self.availableProfiles
        }
        .task {
            self.company.sortProfiles(.teacher)
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.light)
        .frame(minWidth: 460)
        .navigationDestination(isPresented: self.$navigateToTeacherCreation) {
            CreateTeacherProfileView()
        }
        .sheet(isPresented: self.$showEditProfileTeacher) {
            NavigationStack {
                CreateTeacherProfileView()
            }
        }
        .alert("Mode découverte", isPresented: self.$settings.showConnectInvite) {
            IdentificationIsNeededAlertLabel()
        } message: {
            Text(
                "Ce mode ne vous permet pas de créer des profils ou d'enregistrer votre utilisation de l'application. \nVoulez-vous vous identifier ?"
            )
        }
    }

    // MARK: Private

    @State private var showEditProfileTeacher: Bool = false
    @State private var navigateToTeacherCreation: Bool = false

    private var editButton: some View {
        Button {
            if self.settings.companyIsConnected {
                self.company.editProfile(.teacher)
                self.showEditProfileTeacher.toggle()
            } else {
                self.settings.showConnectInvite.toggle()
            }
        } label: {
            Image(systemName: "pencil")
        }
        // TODO: (@ui/ux) - Design System - replace with Leka font
        .buttonStyle(CircledIcon_NoFeedback_ButtonStyle(font: .body))
    }

    private var header: some View {
        HStack(spacing: 20) {
            if !self.navigationVM.showProfileEditor {
                Spacer()
            }
            Text("Qui êtes-vous ?")
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
            if self.navigationVM.showProfileEditor {
                Spacer()
            }
            self.addButton()
            if !self.navigationVM.showProfileEditor {
                Spacer()
            }
            if self.navigationVM.showProfileEditor {
                self.editButton
            }
        }
        .padding(20)
    }

    private var teachersSet: some View {
        ForEach(self.company.currentCompany.teachers) { teacher in
            TeacherSet_AvatarCell(teacher: teacher)
        }
    }

    @ViewBuilder
    private var availableProfiles: some View {
        if !self.navigationVM.showProfileEditor, self.sixMax() {
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    self.teachersSet
                }
                .offset(y: -100)
                Spacer()
            }
        } else {
            ScrollView(showsIndicators: false) {
                let columns = Array(
                    repeating: GridItem(spacing: 20), count: navigationVM.showProfileEditor ? 3 : 6
                )
                LazyVGrid(columns: columns, spacing: 20) {
                    self.teachersSet
                }
                .padding(.bottom, 20)
            }
            ._safeAreaInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
    }

    // check if less than 7 profiles to display in order to adapt Layout (HStack vs. Scrollable Grid)
    private func sixMax() -> Bool {
        self.company.currentCompany.teachers.count < 7
    }

    @ViewBuilder
    private func addButton() -> some View {
        Button {
            if self.viewRouter.currentPage == .welcome {
                // Existing company is connected, we're in the selector here
                self.company.resetBufferProfile(.teacher)
                self.navigateToTeacherCreation.toggle()
            } else {
                if self.settings.companyIsConnected {
                    self.company.editingProfile = false
                    self.company.resetBufferProfile(.teacher)
                    self.showEditProfileTeacher.toggle()
                } else {
                    self.settings.showConnectInvite.toggle()
                }
            }
        } label: {
            Image(systemName: "plus")
        }
        // TODO: (@ui/ux) - Design System - replace with Leka font
        .buttonStyle(CircledIcon_NoFeedback_ButtonStyle(font: .body))
    }
}
