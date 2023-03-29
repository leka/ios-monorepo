//
//  CompanyViewModel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 11/1/23.
//

import SwiftUI

class CompanyViewModel: ObservableObject {

	@Published var currentCompany = Company(mail: "", password: "", teachers: [], users: [])
	@Published var profilesInUse: [UserType: UUID] = [.teacher: UUID(), .user: UUID()]
	@Published var selectedProfiles: [UserType: UUID] = [.teacher: UUID(), .user: UUID()]

	// Buffer profiles to temporarilly store changes
	@Published var bufferTeacher = Teacher(name: "", avatar: "accompanying_white", jobs: [])
	@Published var bufferUser = User(name: "", avatar: "user_white", reinforcer: 1)
	@Published var editingProfile: Bool = false

	// For the tests
	@Published var willBeDeletedFakeFollowUpNumberOfCells: Int = 0

	// MARK: - METHODS

	// Account Managment
	func disconnect() {
		currentCompany = Company(mail: "", password: "", teachers: [], users: [])
		profilesInUse = [.teacher: UUID(), .user: UUID()]
		selectedProfiles = [.teacher: UUID(), .user: UUID()]
		resetBufferProfile(.teacher)
		resetBufferProfile(.user)
	}

	// Profiles Managment Methods
	func assignCurrentProfiles() {
		profilesInUse = selectedProfiles
	}
	// add this after sorting if POP
	func preselectCurrentProfiles() {
		selectedProfiles = profilesInUse
	}

	// Sort profiles (alpabetically + current first) before displaying them in a ProfileSet (Selector || Editor)
	func sortProfiles(_ type: UserType) {
		switch type {
			case .teacher:
				currentCompany.teachers.sort { $0.name < $1.name }
				if let i = currentCompany.teachers.firstIndex(where: { $0.id == profilesInUse[.teacher] }) {
					currentCompany.teachers.move(fromOffsets: [i], toOffset: 0)
				}
			case .user:
				currentCompany.users.sort { $0.name < $1.name }
				if let i = currentCompany.users.firstIndex(where: { $0.id == profilesInUse[.user] }) {
					currentCompany.users.move(fromOffsets: [i], toOffset: 0)
				}
		}
		preselectCurrentProfiles()
	}

	func getSelectedProfileAvatar(_ type: UserType) -> String {
		switch type {
			case .teacher: return bufferTeacher.avatar
			case .user: return bufferUser.avatar
		}
	}

	func getProfileDataFor(_ type: UserType, id: UUID) -> [String] {
		switch type {
			case .teacher:
				guard let i = currentCompany.teachers.firstIndex(where: { $0.id == id }) else {
					return ["accompanying_blue", "Accompagnant"]
				}
				return [currentCompany.teachers[i].avatar, currentCompany.teachers[i].name]
			case .user:
				guard let i = currentCompany.users.firstIndex(where: { $0.id == id }) else {
					return [(!profileIsAssigned(.user) ? "question_mark" : "user_blue"), "Utilisateur"]
				}
				return [currentCompany.users[i].avatar, currentCompany.users[i].name]
		}
	}

	func getCurrentUserReinforcer() -> Int {
		guard let i = currentCompany.users.firstIndex(where: { $0.id == profilesInUse[.user] }) else {
			return 1
		}
		return currentCompany.users[i].reinforcer
	}

	func getAllAvatarsOf(_ type: UserType) -> [[UUID: String]] {
		switch type {
			case .teacher: return currentCompany.teachers.map { [$0.id: $0.avatar] }
			case .user: return currentCompany.users.map { [$0.id: $0.avatar] }
		}
	}

	func getAllProfilesIDFor(_ type: UserType) -> [UUID] {
		switch type {
			case .teacher: return currentCompany.teachers.map { $0.id }
			case .user: return currentCompany.users.map { $0.id }
		}
	}

	func resetBufferProfile(_ type: UserType) {
		switch type {
			case .teacher: bufferTeacher = Teacher(name: "", avatar: "accompanying_white", jobs: [])
			case .user: bufferUser = User(name: "", avatar: "user_white", reinforcer: 1)
		}
	}

	// Selections
	func emptyProfilesSelection() {
		selectedProfiles[.user] = UUID()
		selectedProfiles[.teacher] = UUID()
	}

	func profileIsSelected(_ type: UserType) -> Bool {
		switch type {
			case .teacher: return currentCompany.teachers.map { $0.id }.contains(selectedProfiles[.teacher])
			case .user: return currentCompany.users.map { $0.id }.contains(selectedProfiles[.user])
		}
	}

	func profileIsCurrent(_ type: UserType, id: UUID) -> Bool {
		switch type {
			case .teacher: return profilesInUse[.teacher] == id
			case .user: return profilesInUse[.user] == id
		}
	}

	func profileIsAssigned(_ type: UserType) -> Bool {
		switch type {
			case .teacher: return currentCompany.teachers.map { $0.id }.contains(profilesInUse[.teacher])
			case .user: return currentCompany.users.map { $0.id }.contains(profilesInUse[.user])
		}
	}

	func selectionSetIsCorrect() -> Bool {
		return currentCompany.teachers.map { $0.id }.contains(selectedProfiles[.teacher])
			&& currentCompany.users.map { $0.id }.contains(selectedProfiles[.user])
	}

	// Edit selected profile
	func editProfile(_ type: UserType) {
		switch type {
			case .teacher:
				if let i = currentCompany.teachers.firstIndex(where: { $0.id == selectedProfiles[.teacher] }) {
					bufferTeacher = currentCompany.teachers[i]
				}
			case .user:
				if let i = currentCompany.users.firstIndex(where: { $0.id == selectedProfiles[.user] }) {
					bufferUser = currentCompany.users[i]
				}
		}
		editingProfile = true
	}

	func setBufferAvatar(_ img: String, for type: UserType) {
		switch type {
			case .teacher: bufferTeacher.avatar = img
			case .user: bufferUser.avatar = img
		}
	}

	func resetBufferAvatar(_ type: UserType) {
		switch type {
			case .teacher: bufferTeacher.avatar = ""
			case .user: bufferUser.avatar = ""
		}
	}

	// Save profiles changes
	func saveProfileChanges(_ type: UserType) {
		switch type {
			case .teacher:
				if let i = currentCompany.teachers.firstIndex(where: { $0.id == bufferTeacher.id }) {
					currentCompany.teachers[i] = bufferTeacher
				} else {
					addTeacherProfile()
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
					resetBufferProfile(.teacher)
				}

			case .user:
				if let i = currentCompany.users.firstIndex(where: { $0.id == bufferUser.id }) {
					currentCompany.users[i] = bufferUser
				} else {
					addUserProfile()
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
					resetBufferProfile(.user)
				}
		}
		editingProfile = false
	}

	// Add New Profiles
	func addTeacherProfile() {
		if bufferTeacher.avatar == "accompanying_white" {
			bufferTeacher.avatar = "accompanying_blue"
		}
		currentCompany.teachers.insert(bufferTeacher, at: 0)
		selectedProfiles[.teacher] = bufferTeacher.id
	}

	func addUserProfile() {
		if bufferUser.avatar == "user_white" {
			bufferUser.avatar = "user_blue"
		}
		currentCompany.users.insert(bufferUser, at: 0)
		selectedProfiles[.user] = bufferUser.id
	}

	// Delete profiles
	func deleteProfile(_ type: UserType) {
		switch type {
			case .teacher:
				currentCompany.teachers.removeAll(where: { bufferTeacher.id == $0.id })
				profilesInUse[.teacher] = UUID()
				selectedProfiles[.teacher] = UUID()
				editingProfile = false

			case .user:
				currentCompany.users.removeAll(where: { bufferUser.id == $0.id })
				profilesInUse[.user] = UUID()
				selectedProfiles[.user] = UUID()
				editingProfile = false
		}
	}

	// MARK: - Mock DATA - DiscoveryMode
	func setupDiscoveryCompany() {
		currentCompany = DiscoveryCompany().discoveryCompany
		profilesInUse[.teacher] = currentCompany.teachers[0].id
		profilesInUse[.user] = currentCompany.users[0].id
	}

	// DELETE once we fetch from server
	// This will only be used for tests + maybe congresses??
	let leka = Company(
		mail: "test@leka.io",
		password: "lekaleka",
		teachers: [
			Teacher(name: "Ladislas", avatar: "avatars_pictograms-foods-fruits-banana_yellow-00FB", jobs: ["CEO"]),
			Teacher(name: "Hortense", avatar: "avatars_leka_explorer", jobs: ["Designer"]),
			Teacher(name: "Lucie", avatar: "avatars_leka-girl-6a", jobs: ["COO"]),
			Teacher(name: "Mathieu", avatar: "avatars_pictograms-animals-sea-crab_red-003E", jobs: ["Developer"]),
			Teacher(name: "Jean-Christophe B.", avatar: "avatars_leka_moon", jobs: ["Pédopsychiatre"]),
		],
		users: [
			User(name: "Alice", avatar: "avatars_leka_sunglasses_blue", reinforcer: 3),
			User(name: "Olivia", avatar: "avatars_leka_star", reinforcer: 5),
			User(name: "Elessa", avatar: "avatars_girl-3e-62", reinforcer: 1),
			User(name: "Lucas", avatar: "avatars_pictograms-animals-farm-rooster_white-006B", reinforcer: 2),
			User(name: "Maximilien", avatar: "avatars_pictograms-foods-vegetables-corn_yellow-00E3", reinforcer: 4),
			User(name: "Stéphane", avatar: "avatars_pictograms-animals-sea-turtle_green-0041", reinforcer: 3),
			User(name: "Lila", avatar: "avatars_pictograms-animals-sea-crab_red-003E", reinforcer: 2),
			User(name: "Pierre", avatar: "avatars_boy-2d", reinforcer: 1),
			User(name: "Baptiste", avatar: "avatars_pictograms-animals-forest-hedgehog_brown-0062", reinforcer: 5),
			User(name: "Éloïse", avatar: "avatars_sun", reinforcer: 4),
			User(name: "Clément", avatar: "avatars_leka-boy-2b", reinforcer: 2),
			User(name: "Simon", avatar: "avatars_leka_marine", reinforcer: 3),
			User(
				name: "Jean-Pierre Marie", avatar: "avatars_pictograms-foods-fruits-strawberry_red-00FD", reinforcer: 4),
		])

}
