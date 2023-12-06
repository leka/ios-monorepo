// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

class CompanyViewModel: ObservableObject {
    @Published var currentCompany = Company(mail: "", password: "", teachers: [], users: [])
    @Published var profilesInUse: [UserType: UUID] = [.teacher: UUID(), .user: UUID()]
    @Published var selectedProfiles: [UserType: UUID] = [.teacher: UUID(), .user: UUID()]

    // Buffer profiles to temporarilly store changes
    @Published var bufferTeacher = Teacher(name: "", avatar: DesignKitAsset.Avatars.accompanyingWhite.name, jobs: [])
    @Published var bufferUser = User(name: "", avatar: DesignKitAsset.Avatars.userWhite.name, reinforcer: 1)
    @Published var editingProfile: Bool = false

    // MARK: - METHODS

    // Account Managment
    func disconnect() {
        currentCompany = Company(mail: "", password: "", teachers: [], users: [])
        profilesInUse = [.teacher: UUID(), .user: UUID()]
        selectedProfiles = [.teacher: UUID(), .user: UUID()]
        resetBufferProfile(.teacher)
        resetBufferProfile(.user)
    }

    func assignCurrentProfiles() {
        profilesInUse = selectedProfiles
    }

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
            case .teacher: bufferTeacher.avatar
            case .user: bufferUser.avatar
        }
    }

    func getProfileDataFor(_ type: UserType, id: UUID) -> [String] {
        switch type {
            case .teacher:
                guard let i = currentCompany.teachers.firstIndex(where: { $0.id == id }) else {
                    return [
                        DesignKitAsset.Avatars.accompanyingBlue.name,
                        "Accompagnant",
                    ]
                }
                return [currentCompany.teachers[i].avatar, currentCompany.teachers[i].name]
            case .user:
                guard let i = currentCompany.users.firstIndex(where: { $0.id == id }) else {
                    return [
                        !profileIsAssigned(.user)
                            ? DesignKitAsset.Avatars.questionMark.name : DesignKitAsset.Avatars.userBlue.name,
                        "Utilisateur",
                    ]
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

    func getReinforcerFor(index: Int) -> UIImage {
        switch index {
            case 2: DesignKitAsset.Reinforcers.spinBlinkBlueViolet.image
            case 3: DesignKitAsset.Reinforcers.fire.image
            case 4: DesignKitAsset.Reinforcers.sprinkles.image
            case 5: DesignKitAsset.Reinforcers.rainbow.image
            default: DesignKitAsset.Reinforcers.spinBlinkGreenOff.image
        }
    }

    func getAllAvatarsOf(_ type: UserType) -> [[UUID: String]] {
        switch type {
            case .teacher: currentCompany.teachers.map { [$0.id: $0.avatar] }
            case .user: currentCompany.users.map { [$0.id: $0.avatar] }
        }
    }

    func getAllProfilesIDFor(_ type: UserType) -> [UUID] {
        switch type {
            case .teacher: currentCompany.teachers.map(\.id)
            case .user: currentCompany.users.map(\.id)
        }
    }

    func resetBufferProfile(_ type: UserType) {
        switch type {
            case .teacher:
                bufferTeacher = Teacher(
                    name: "",
                    avatar: DesignKitAsset.Avatars.accompanyingWhite.name,
                    jobs: []
                )
            case .user:
                bufferUser = User(
                    name: "",
                    avatar: DesignKitAsset.Avatars.userWhite.name,
                    reinforcer: 1
                )
        }
    }

    func emptyProfilesSelection() {
        selectedProfiles[.user] = UUID()
        selectedProfiles[.teacher] = UUID()
    }

    func profileIsSelected(_ type: UserType) -> Bool {
        switch type {
            case .teacher: currentCompany.teachers.map(\.id).contains(selectedProfiles[.teacher])
            case .user: currentCompany.users.map(\.id).contains(selectedProfiles[.user])
        }
    }

    func profileIsCurrent(_ type: UserType, id: UUID) -> Bool {
        switch type {
            case .teacher: profilesInUse[.teacher] == id
            case .user: profilesInUse[.user] == id
        }
    }

    func profileIsAssigned(_ type: UserType) -> Bool {
        switch type {
            case .teacher: currentCompany.teachers.map(\.id).contains(profilesInUse[.teacher])
            case .user: currentCompany.users.map(\.id).contains(profilesInUse[.user])
        }
    }

    func selectionSetIsCorrect() -> Bool {
        currentCompany.teachers.map(\.id).contains(selectedProfiles[.teacher])
            && currentCompany.users.map(\.id).contains(selectedProfiles[.user])
    }

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

    func addTeacherProfile() {
        if bufferTeacher.avatar == DesignKitAsset.Avatars.accompanyingWhite.name {
            bufferTeacher.avatar = DesignKitAsset.Avatars.accompanyingBlue.name
        }
        currentCompany.teachers.insert(bufferTeacher, at: 0)
        selectedProfiles[.teacher] = bufferTeacher.id
    }

    func addUserProfile() {
        if bufferUser.avatar == DesignKitAsset.Avatars.userWhite.name {
            bufferUser.avatar = DesignKitAsset.Avatars.userBlue.name
        }
        currentCompany.users.insert(bufferUser, at: 0)
        selectedProfiles[.user] = bufferUser.id
    }

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

    // MARK: - DiscoveryMode

    func setupDiscoveryCompany() {
        currentCompany = DiscoveryCompany().discoveryCompany
        profilesInUse[.teacher] = currentCompany.teachers[0].id
        profilesInUse[.user] = currentCompany.users[0].id
    }
}
