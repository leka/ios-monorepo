// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CreateTeacherProfileView

struct CreateTeacherProfileView: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    AvatarPickerTriggerButton_Teachers(navigate: self.$navigateToAvatarPicker)
                        .padding(.top, 30)

                    Group {
                        self.nameField
                        JobPickerTrigger(navigate: self.$navigateToJobPicker)
                    }
                    self.accessoryView
                    Spacer()
                    DeleteProfileButton(show: self.$showDeleteConfirmation)
                }
            }
        }
        .interactiveDismissDisabled()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(self.navigationVM.showProfileEditor ? .visible : .automatic, for: .navigationBar)
        .navigationDestination(isPresented: self.$navigateToAvatarPicker) {
            AvatarPicker_Teachers()
        }
        .navigationDestination(isPresented: self.$navigateToJobPicker) {
            JobPicker()
        }
        .navigationDestination(isPresented: self.$navigateToSignup3) {
            SignupStep3()
        }
        .alert("Supprimer le profil", isPresented: self.$showDeleteConfirmation) {
            self.alertContent
        } message: {
            Text(
                "Vous êtes sur le point de supprimer le profil accompagnant de \(self.company.bufferTeacher.name). \nCette action est irreversible."
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) { self.navigationTitle }
            ToolbarItem(placement: .navigationBarLeading) { self.adaptiveBackButton }
            ToolbarItem(placement: .navigationBarTrailing) { self.validateButton }
        }
        .preferredColorScheme(.light)
    }

    @ViewBuilder
    var validateButton: some View {
        if self.viewRouter.currentPage == .welcome {
            EmptyView()
        } else {
            Button(
                action: {
                    self.company.saveProfileChanges(.teacher)
                    if self.settings.companyIsLoggingIn {
                        self.company.assignCurrentProfiles()
                        self.viewRouter.currentPage = .home
                        self.settings.companyIsLoggingIn = false
                    } else {
                        self.dismiss()
                    }
                    hideKeyboard()
                },
                label: {
                    self.validateButtonLabel
                }
            )
            .disabled(self.company.bufferTeacher.name.isEmpty)
        }
    }

    // MARK: Private

    @FocusState private var focusedField: FormField?
    @State private var isEditing = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var navigateToSignup3: Bool = false
    @State private var navigateToJobPicker: Bool = false
    @State private var navigateToAvatarPicker: Bool = false

    private var nameField: some View {
        LekaTextField(
            label: "Nom d'accompagnant", entry: self.$company.bufferTeacher.name, isEditing: self.$isEditing, type: .name,
            focused: _focusedField,
            action: {
                self.focusedField = nil
            }
        )
        .padding(2)
        .onAppear {
            self.focusedField = .name
        }
    }

    private var alertContent: some View {
        Button(role: .destructive) {
            self.company.deleteProfile(.teacher)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismiss()
            }
        } label: {
            Text("Supprimer")
        }
    }

    @ViewBuilder
    private var accessoryView: some View {
        if self.viewRouter.currentPage == .welcome {
            Button(
                action: {
                    self.navigateToSignup3.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.company.addTeacherProfile()
                        self.company.assignCurrentProfiles()
                    }
                },
                label: {
                    Text("Enregistrer ce profil")
                }
            )
            .disabled(self.company.bufferTeacher.name.isEmpty)
            .buttonStyle(
                // TODO: (@ui/ux) - Design System - replace with Leka font
                BorderedCapsule_NoFeedback_ButtonStyle(
                    font: .body,
                    color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                    width: self.metrics.tileBtnWidth
                )
            )
        } else {
            EmptyView()
        }
    }

    // Toolbar
    private var navigationTitle: some View {
        Text(self.company.editingProfile ? "Éditer un profil accompagnant" : "Créer un profil accompagnant")
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.headline)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var validateButtonLabel: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle")
            Text("Enregistrer")
        }
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        .contentShape(Rectangle())
    }

    private var adaptiveBackButton: some View {
        Button {
            // go back without saving
            self.dismiss()
            self.company.editingProfile = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.company.resetBufferProfile(.teacher)
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                if self.navigationVM.showProfileEditor {
                    Text("Annuler")
                } else {
                    Text("Retour")
                }
            }
        }
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }
}

// MARK: - CreateProfileView_Previews

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeacherProfileView()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(NavigationViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
