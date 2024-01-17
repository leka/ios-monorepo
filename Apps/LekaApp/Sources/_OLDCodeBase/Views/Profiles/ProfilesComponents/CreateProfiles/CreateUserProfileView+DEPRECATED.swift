// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CreateUserProfileViewDeprecated

struct CreateUserProfileViewDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var viewRouter: ViewRouterDeprecated
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    AvatarPickerTriggerButton_Users(navigate: self.$navigateToAvatarPicker)
                        .padding(.top, 30)

                    self.nameField
                    ReinforcerPicker()
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
            AvatarPicker_Users()
        }
        .navigationDestination(isPresented: self.$navigateToSignupFinalStep) {
            SignupFinalStepDeprecated()
        }
        .alert("Supprimer le profil", isPresented: self.$showDeleteConfirmation) {
            self.alertContent
        } message: {
            Text(
                "Vous êtes sur le point de supprimer le profil utilisateur de \(self.company.bufferUser.name). \nCette action est irreversible."
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) { self.navigationTitle }
            ToolbarItem(placement: .navigationBarLeading) { self.adaptativeBackButton }
            ToolbarItem(placement: .navigationBarTrailing) { self.validateButton }
        }
        .preferredColorScheme(.light)
    }

    // MARK: Private

    @FocusState private var focusedField: FormField?
    @State private var isEditing = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var navigateToSignupFinalStep: Bool = false
    @State private var navigateToAvatarPicker: Bool = false

    private var nameField: some View {
        LekaTextFieldDeprecated(
            label: "Nom d'utilisateur", entry: self.$company.bufferUser.name, isEditing: self.$isEditing, type: .name,
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
            self.company.deleteProfile(.user)
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
                    self.navigateToSignupFinalStep.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.company.addUserProfile()
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
        Text(self.company.editingProfile ? "Éditer un profil utilisateur" : "Créer un profil utilisateur")
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.headline)
    }

    private var adaptativeBackButton: some View {
        Button {
            // Leave without saving
            self.dismiss()
            self.company.editingProfile = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.company.resetBufferProfile(.user)
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                if self.viewRouter.currentPage == .welcome {
                    Text("Retour")
                } else {
                    Text("Annuler")
                }
            }
        }
    }

    private var validateButton: some View {
        Group {
            if self.navigationVM.showProfileEditor {
                Button(
                    action: {
                        // Save changes and leave
                        self.company.saveProfileChanges(.user)
                        self.dismiss()
                    },
                    label: {
                        self.validateButtonLabel
                    }
                )
            } else if self.viewRouter.currentPage == .welcome {
                EmptyView()
            } else {
                // User Selector before launching an activity
                Button(
                    action: {
                        self.dismiss()
                        hideKeyboard()
                        self.company.saveProfileChanges(.user)
                        self.company.assignCurrentProfiles()
                    },
                    label: {
                        self.validateButtonLabel
                    }
                )
            }
        }
        .disabled(self.company.bufferUser.name.isEmpty)
    }

    private var validateButtonLabel: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle")
            Text("Enregistrer")
        }

        .contentShape(Rectangle())
    }
}

// MARK: - CreateUserProfileView_Previews

struct CreateUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserProfileViewDeprecated()
            .environmentObject(CompanyViewModelDeprecated())
            .environmentObject(ViewRouterDeprecated())
            .environmentObject(NavigationViewModel())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
