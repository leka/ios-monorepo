// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CreateUserProfileView

struct CreateUserProfileView: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    AvatarPickerTriggerButton_Users(navigate: $navigateToAvatarPicker)
                        .padding(.top, 30)

                    nameField
                    ReinforcerPicker()
                    accessoryView
                    Spacer()
                    DeleteProfileButton(show: $showDeleteConfirmation)
                }
            }
        }
        .interactiveDismissDisabled()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(navigationVM.showProfileEditor ? .visible : .automatic, for: .navigationBar)
        .navigationDestination(isPresented: $navigateToAvatarPicker) {
            AvatarPicker_Users()
        }
        .navigationDestination(isPresented: $navigateToSignupFinalStep) {
            SignupFinalStep()
        }
        .alert("Supprimer le profil", isPresented: $showDeleteConfirmation) {
            alertContent
        } message: {
            Text(
                "Vous êtes sur le point de supprimer le profil utilisateur de \(company.bufferUser.name). \nCette action est irreversible."
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) { navigationTitle }
            ToolbarItem(placement: .navigationBarLeading) { adaptativeBackButton }
            ToolbarItem(placement: .navigationBarTrailing) { validateButton }
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
        LekaTextField(
            label: "Nom d'utilisateur", entry: $company.bufferUser.name, isEditing: $isEditing, type: .name,
            focused: _focusedField,
            action: {
                focusedField = nil
            }
        )
        .padding(2)
        .onAppear {
            focusedField = .name
        }
    }

    private var alertContent: some View {
        Button(role: .destructive) {
            company.deleteProfile(.user)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                dismiss()
            }
        } label: {
            Text("Supprimer")
        }
    }

    @ViewBuilder
    private var accessoryView: some View {
        if viewRouter.currentPage == .welcome {
            Button(
                action: {
                    navigateToSignupFinalStep.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        company.addUserProfile()
                        company.assignCurrentProfiles()
                    }
                },
                label: {
                    Text("Enregistrer ce profil")
                }
            )
            .disabled(company.bufferTeacher.name.isEmpty)
            .buttonStyle(
                BorderedCapsule_NoFeedback_ButtonStyle(
                    font: metrics.reg17,
                    color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                    width: metrics.tileBtnWidth)
            )
        } else {
            EmptyView()
        }
    }

    // Toolbar
    private var navigationTitle: some View {
        Text(company.editingProfile ? "Éditer un profil utilisateur" : "Créer un profil utilisateur")
            .font(metrics.semi17)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var adaptativeBackButton: some View {
        Button {
            // Leave without saving
            dismiss()
            company.editingProfile = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                company.resetBufferProfile(.user)
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                if viewRouter.currentPage == .welcome {
                    Text("Retour")
                } else {
                    Text("Annuler")
                }
            }
        }
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var validateButton: some View {
        Group {
            if navigationVM.showProfileEditor {
                Button(
                    action: {
                        // Save changes and leave
                        company.saveProfileChanges(.user)
                        dismiss()
                    },
                    label: {
                        validateButtonLabel
                    })
            } else if viewRouter.currentPage == .welcome {
                EmptyView()
            } else {
                // User Selector before launching an activity
                Button(
                    action: {
                        dismiss()
                        hideKeyboard()
                        company.saveProfileChanges(.user)
                        company.assignCurrentProfiles()
                    },
                    label: {
                        validateButtonLabel
                    })
            }
        }
        .disabled(company.bufferUser.name.isEmpty)
    }

    private var validateButtonLabel: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle")
            Text("Enregistrer")
        }
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        .contentShape(Rectangle())
    }
}

// MARK: - CreateUserProfileView_Previews

struct CreateUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserProfileView()
            .environmentObject(CompanyViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(NavigationViewModel())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
