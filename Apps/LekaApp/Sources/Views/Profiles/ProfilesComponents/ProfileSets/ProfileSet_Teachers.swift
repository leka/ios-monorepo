// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
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
            company.sortProfiles(.teacher)
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.light)
        .frame(minWidth: 460)
        .navigationDestination(isPresented: $navigateToTeacherCreation) {
            CreateTeacherProfileView()
        }
        .sheet(isPresented: $showEditProfileTeacher) {
            NavigationStack {
                CreateTeacherProfileView()
            }
        }
        .alert("Mode découverte", isPresented: $settings.showConnectInvite) {
            IdentificationIsNeededAlertLabel()
        } message: {
            Text( // swiftlint:disable:next line_length
                "Ce mode ne vous permet pas de créer des profils ou d'enregistrer votre utilisation de l'application. \nVoulez-vous vous identifier ?"
            )
        }
    }

    // MARK: Private

    @State private var showEditProfileTeacher: Bool = false
    @State private var navigateToTeacherCreation: Bool = false

    private var editButton: some View {
        Button {
            if settings.companyIsConnected {
                company.editProfile(.teacher)
                showEditProfileTeacher.toggle()
            } else {
                settings.showConnectInvite.toggle()
            }
        } label: {
            Image(systemName: "pencil")
        }
        .buttonStyle(CircledIcon_NoFeedback_ButtonStyle(font: metrics.bold16))
    }

    private var header: some View {
        HStack(spacing: 20) {
            if !navigationVM.showProfileEditor {
                Spacer()
            }
            Text("Qui êtes-vous ?")
                .font(metrics.reg17)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            if navigationVM.showProfileEditor {
                Spacer()
            }
            addButton()
            if !navigationVM.showProfileEditor {
                Spacer()
            }
            if navigationVM.showProfileEditor {
                editButton
            }
        }
        .padding(20)
    }

    private var teachersSet: some View {
        ForEach(company.currentCompany.teachers) { teacher in
            TeacherSet_AvatarCell(teacher: teacher)
        }
    }

    @ViewBuilder
    private var availableProfiles: some View {
        if !navigationVM.showProfileEditor, sixMax() {
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    teachersSet
                }
                .offset(y: -100)
                Spacer()
            }
        } else {
            ScrollView(showsIndicators: false) {
                let columns = Array(
                    repeating: GridItem(spacing: 20), count: navigationVM.showProfileEditor ? 3 : 6)
                LazyVGrid(columns: columns, spacing: 20) {
                    teachersSet
                }
                .padding(.bottom, 20)
            }
            ._safeAreaInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
    }

    // check if less than 7 profiles to display in order to adapt Layout (HStack vs. Scrollable Grid)
    private func sixMax() -> Bool {
        company.currentCompany.teachers.count < 7
    }

    @ViewBuilder
    private func addButton() -> some View {
        Button {
            if viewRouter.currentPage == .welcome {
                // Existing company is connected, we're in the selector here
                company.resetBufferProfile(.teacher)
                navigateToTeacherCreation.toggle()
            } else {
                if settings.companyIsConnected {
                    company.editingProfile = false
                    company.resetBufferProfile(.teacher)
                    showEditProfileTeacher.toggle()
                } else {
                    settings.showConnectInvite.toggle()
                }
            }
        } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(CircledIcon_NoFeedback_ButtonStyle(font: metrics.bold16))
    }
}
