// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CreateUserProfileView: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    @FocusState private var focusedField: FormField?
    @State private var isEditing = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var navigateToSignupFinalStep: Bool = false
    @State private var navigateToAvatarPicker: Bool = false

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
        .toolbarBackground(viewRouter.currentPage == .profiles ? .visible : .automatic, for: .navigationBar)
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
                    color: .accentColor,
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
            .foregroundColor(.accentColor)
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
        .tint(.accentColor)
    }

    private var validateButton: some View {
        Group {
            if viewRouter.currentPage == .profiles {
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
        .tint(.accentColor)
        .contentShape(Rectangle())
    }
}

struct CreateUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserProfileView()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
