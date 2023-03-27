//
//  CreateProfileView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/11/22.
//

import SwiftUI

struct CreateTeacherProfileView: View {

	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var metrics: UIMetrics
	@Environment(\.dismiss) var dismiss

	@FocusState private var focusedField: FormField?
	@State private var isEditing = false
	@State private var showDeleteConfirmation: Bool = false
	@State private var navigateToSignup3: Bool = false
	@State private var navigateToJobPicker: Bool = false
	@State private var navigateToAvatarPicker: Bool = false

	var body: some View {
		ZStack {
			Color.white.edgesIgnoringSafeArea(.top)

			ScrollView(showsIndicators: false) {
				VStack(spacing: 30) {
					AvatarPickerTriggerButton_Teachers(navigate: $navigateToAvatarPicker)
						.padding(.top, 30)

					Group {
						nameField
						JobPickerTrigger(navigate: $navigateToJobPicker)
					}
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
			AvatarPicker_Teachers()
		}
		.navigationDestination(isPresented: $navigateToJobPicker) {
			JobPicker()
		}
		.navigationDestination(isPresented: $navigateToSignup3) {
			SignupStep3()
		}
		.alert("Supprimer le profil", isPresented: $showDeleteConfirmation) {
			alertContent
		} message: {
			Text(
				"Vous êtes sur le point de supprimer le profil accompagnant de \(company.bufferTeacher.name). \nCette action est irreversible."
			)
		}
		.toolbar {
			ToolbarItem(placement: .principal) { navigationTitle }
			ToolbarItem(placement: .navigationBarLeading) { adaptiveBackButton }
			ToolbarItem(placement: .navigationBarTrailing) { validateButton }
		}
		.preferredColorScheme(.light)
	}

	private var nameField: some View {
		LekaTextField(
			label: "Nom d'accompagnant", entry: $company.bufferTeacher.name, isEditing: $isEditing, type: .name,
			focused: _focusedField,
			action: {
				focusedField = nil
			}
		)
		.onAppear {
			focusedField = .name
		}
	}

	private var alertContent: some View {
		Button(role: .destructive) {
			company.deleteProfile(.teacher)
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
					navigateToSignup3.toggle()
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						company.addTeacherProfile()
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
		Text(company.editingProfile ? "Éditer un profil accompagnant" : "Créer un profil accompagnant")
			.font(metrics.semi17)
			.foregroundColor(.accentColor)
	}

	@ViewBuilder
	var validateButton: some View {
		if viewRouter.currentPage == .welcome {
			EmptyView()
		} else {
			Button(action: {
				company.saveProfileChanges(.teacher)
				if settings.companyIsLoggingIn {
					company.assignCurrentProfiles()
					viewRouter.currentPage = .home
					settings.companyIsLoggingIn = false
				} else {
					dismiss()
				}
				hideKeyboard()
			}) {
				validateButtonLabel
			}
			.disabled(company.bufferTeacher.name.isEmpty)
		}
	}

	private var validateButtonLabel: some View {
		HStack(spacing: 4) {
			Image(systemName: "checkmark.circle")
			Text("Enregistrer")
		}
		.tint(.accentColor)
		.contentShape(Rectangle())
	}

	private var adaptiveBackButton: some View {
		Button {
			// go back without saving
			dismiss()
			company.editingProfile = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				company.resetBufferProfile(.teacher)
			}
		} label: {
			HStack(spacing: 4) {
				Image(systemName: "chevron.left")
				if viewRouter.currentPage == .profiles {
					Text("Annuler")
				} else {
					Text("Retour")
				}
			}
		}
		.tint(.accentColor)
	}
}

struct CreateProfileView_Previews: PreviewProvider {
	static var previews: some View {
		CreateTeacherProfileView()
			.environmentObject(CompanyViewModel())
			.environmentObject(SettingsViewModel())
			.environmentObject(ViewRouter())
			.environmentObject(UIMetrics())
			.previewInterfaceOrientation(.landscapeLeft)
	}
}
