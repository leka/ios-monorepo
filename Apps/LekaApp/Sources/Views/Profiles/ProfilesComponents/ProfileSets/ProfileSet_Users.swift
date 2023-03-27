//
//  ProfileSet_Users.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 15/3/23.
//

import SwiftUI

struct ProfileSet_Users: View {

	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var metrics: UIMetrics
	@Environment(\.dismiss) var dismiss

	@State private var showEditProfileUser: Bool = false

	// check if less than 7 profiles to display in order to adapt Layout (HStack vs. Scrollable Grid)
	private func sixMax() -> Bool {
		return company.currentCompany.users.count < 7
	}

	var body: some View {
		VStack(spacing: 0) {
			header

			// Separator
			Rectangle()
				.fill(Color.accentColor)
				.frame(height: 1)
				.frame(maxWidth: viewRouter.currentPage != .profiles ? 460 : .infinity)

			// Avatars
			availableProfiles
		}
		.task {
			company.sortProfiles(.user)
		}
		.navigationBarTitleDisplayMode(.inline)
		.preferredColorScheme(.light)
		.frame(minWidth: 460)
		.sheet(
			isPresented: $showEditProfileUser,
			content: {
				NavigationStack {
					CreateUserProfileView()
				}
			}
		)
		.alert("Mode découverte", isPresented: $settings.showConnectInvite) {
			IdentificationIsNeededAlertLabel()
		} message: {
			Text(
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
			company.getProfileDataFor(.user, id: company.profilesInUse[.user]!)[0] == "question_mark_blue"
				&& !company.profileIsSelected(.user))
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
			if viewRouter.currentPage != .profiles { Spacer() }
			Text("Qui accompagnez-vous?")
				.font(metrics.reg17)
				.foregroundColor(.accentColor)
			if viewRouter.currentPage == .profiles { Spacer() }
			addButton
			if viewRouter.currentPage != .profiles { Spacer() }
			if viewRouter.currentPage == .profiles {
				editButton
			}
		}
		.padding(20)
	}

	private var usersSet: some View {
		ForEach(company.currentCompany.users) { user in
			UserSet_AvatarCell(of: user)
		}
	}

	@ViewBuilder
	private var availableProfiles: some View {
		if viewRouter.currentPage != .profiles && sixMax() {
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
					repeating: GridItem(spacing: 20), count: viewRouter.currentPage == .profiles ? 3 : 6)
				LazyVGrid(columns: columns, spacing: 20) {
					usersSet
				}
				.padding(.bottom, 20)
			}
			._safeAreaInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
		}
	}
}
