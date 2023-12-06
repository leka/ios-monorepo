// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ProfileSet_Users: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel
    @Environment(\.dismiss) var dismiss

    @State private var showEditProfileUser: Bool = false

    // check if less than 7 profiles to display in order to adapt Layout (HStack vs. Scrollable Grid)
    private func sixMax() -> Bool {
        company.currentCompany.users.count < 7
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            // Separator
            Rectangle()
                .fill(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .frame(height: 1)
                .frame(maxWidth: navigationVM.showProfileEditor ? .infinity : 460)

            // Avatars
            availableProfiles
        }
        .task {
            company.sortProfiles(.user)
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.light)
        .frame(minWidth: 460)
        .sheet(isPresented: $showEditProfileUser) {
            NavigationStack {
                CreateUserProfileView()
            }
        }
        .alert("Mode découverte", isPresented: $settings.showConnectInvite) {
            IdentificationIsNeededAlertLabel()
        } message: {
            Text(  // swiftlint:disable:next line_length
                "Ce mode ne vous permet pas de créer des profils ou d'enregistrer votre utilisation de l'application. \nVoulez-vous vous identifier ?"
            )
        }
    }

    private var editButton: some View {
        Button {
            if settings.companyIsConnected {
                company.editProfile(.user)
                showEditProfileUser.toggle()
            } else {
                settings.showConnectInvite.toggle()
            }
        } label: {
            Image(systemName: "pencil")
        }
        .buttonStyle(CircledIcon_NoFeedback_ButtonStyle(font: metrics.bold16))
        .disabled(
            company.getProfileDataFor(
                .user,
                id: company.profilesInUse[.user]!
            )[0] == DesignKitAsset.Avatars.questionMarkBlue.name
                && !company.profileIsSelected(.user)
        )
    }

    private var addButton: some View {
        Button {
            if settings.companyIsConnected {
                company.editingProfile = false
                company.resetBufferProfile(.user)
                showEditProfileUser.toggle()
            } else {
                settings.showConnectInvite.toggle()
            }
        } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(CircledIcon_NoFeedback_ButtonStyle(font: metrics.bold16))
    }

    private var header: some View {
        HStack(spacing: 20) {
            if !navigationVM.showProfileEditor {
                Spacer()
            }
            Text("Qui accompagnez-vous?")
                .font(metrics.reg17)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            if navigationVM.showProfileEditor {
                Spacer()
            }
            addButton
            if !navigationVM.showProfileEditor {
                Spacer()
            }
            if navigationVM.showProfileEditor {
                editButton
            }
        }
        .padding(20)
    }

    private var usersSet: some View {
        ForEach(company.currentCompany.users) { user in
            UserSet_AvatarCell(user: user)
        }
    }

    @ViewBuilder
    private var availableProfiles: some View {
        if !navigationVM.showProfileEditor, sixMax() {
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    usersSet
                }
                .offset(y: -100)
                Spacer()
            }
        } else {
            ScrollView(showsIndicators: false) {
                let columns = Array(
                    repeating: GridItem(spacing: 20), count: navigationVM.showProfileEditor ? 3 : 6)
                LazyVGrid(columns: columns, spacing: 20) {
                    usersSet
                }
                .padding(.bottom, 20)
            }
            ._safeAreaInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
    }
}
