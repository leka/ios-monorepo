// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

class CompanyViewModelDeprecated: ObservableObject {
    @Published var currentCompany = CompanyDeprecated(mail: "", password: "", teachers: [], users: [])
    @Published var profilesInUse: [UserTypeDeprecated: UUID] = [.teacher: UUID(), .user: UUID()]
    @Published var selectedProfiles: [UserTypeDeprecated: UUID] = [.teacher: UUID(), .user: UUID()]

    // Buffer profiles to temporarilly store changes
    @Published var bufferTeacher = TeacherDeprecated(name: "", avatar: DesignKitAsset.Avatars.accompanyingWhite.name, jobs: [])
    @Published var bufferUser = UserDeprecated(name: "", avatar: DesignKitAsset.Avatars.userWhite.name, reinforcer: 1)
    @Published var editingProfile: Bool = false

    // MARK: - METHODS

    // Account Managment
    func disconnect() {
        self.currentCompany = CompanyDeprecated(mail: "", password: "", teachers: [], users: [])
        self.profilesInUse = [.teacher: UUID(), .user: UUID()]
        self.selectedProfiles = [.teacher: UUID(), .user: UUID()]
        self.resetBufferProfile(.teacher)
        self.resetBufferProfile(.user)
    }

    func assignCurrentProfiles() {
        self.profilesInUse = self.selectedProfiles
    }

    func preselectCurrentProfiles() {
        self.selectedProfiles = self.profilesInUse
    }

    // Sort profiles (alpabetically + current first) before displaying them in a ProfileSet (Selector || Editor)
    func sortProfiles(_ type: UserTypeDeprecated) {
        switch type {
            case .teacher:
                self.currentCompany.teachers.sort { $0.name < $1.name }
                if let i = currentCompany.teachers.firstIndex(where: { $0.id == profilesInUse[.teacher] }) {
                    self.currentCompany.teachers.move(fromOffsets: [i], toOffset: 0)
                }
            case .user:
                self.currentCompany.users.sort { $0.name < $1.name }
                if let i = currentCompany.users.firstIndex(where: { $0.id == profilesInUse[.user] }) {
                    self.currentCompany.users.move(fromOffsets: [i], toOffset: 0)
                }
        }
        self.preselectCurrentProfiles()
    }

    func getSelectedProfileAvatar(_ type: UserTypeDeprecated) -> String {
        switch type {
            case .teacher: self.bufferTeacher.avatar
            case .user: self.bufferUser.avatar
        }
    }

    func getProfileDataFor(_ type: UserTypeDeprecated, id: UUID) -> [String] {
        switch type {
            case .teacher:
                guard let i = currentCompany.teachers.firstIndex(where: { $0.id == id }) else {
                    return [
                        DesignKitAsset.Avatars.accompanyingBlue.name,
                        "Accompagnant",
                    ]
                }
                return [self.currentCompany.teachers[i].avatar, self.currentCompany.teachers[i].name]
            case .user:
                guard let i = currentCompany.users.firstIndex(where: { $0.id == id }) else {
                    return [
                        !self.profileIsAssigned(.user)
                            ? DesignKitAsset.Avatars.questionMark.name : DesignKitAsset.Avatars.userBlue.name,
                        "Utilisateur",
                    ]
                }
                return [self.currentCompany.users[i].avatar, self.currentCompany.users[i].name]
        }
    }

    func getCurrentUserReinforcer() -> Int {
        guard let i = currentCompany.users.firstIndex(where: { $0.id == profilesInUse[.user] }) else {
            return 1
        }
        return self.currentCompany.users[i].reinforcer
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

    func getAllAvatarsOf(_ type: UserTypeDeprecated) -> [[UUID: String]] {
        switch type {
            case .teacher: self.currentCompany.teachers.map { [$0.id: $0.avatar] }
            case .user: self.currentCompany.users.map { [$0.id: $0.avatar] }
        }
    }

    func getAllProfilesIDFor(_ type: UserTypeDeprecated) -> [UUID] {
        switch type {
            case .teacher: self.currentCompany.teachers.map(\.id)
            case .user: self.currentCompany.users.map(\.id)
        }
    }

    func resetBufferProfile(_ type: UserTypeDeprecated) {
        switch type {
            case .teacher:
                self.bufferTeacher = TeacherDeprecated(
                    name: "",
                    avatar: DesignKitAsset.Avatars.accompanyingWhite.name,
                    jobs: []
                )
            case .user:
                self.bufferUser = UserDeprecated(
                    name: "",
                    avatar: DesignKitAsset.Avatars.userWhite.name,
                    reinforcer: 1
                )
        }
    }

    func emptyProfilesSelection() {
        self.selectedProfiles[.user] = UUID()
        self.selectedProfiles[.teacher] = UUID()
    }

    func profileIsSelected(_ type: UserTypeDeprecated) -> Bool {
        switch type {
            case .teacher:
                if let id = selectedProfiles[.teacher] {
                    return self.currentCompany.teachers.map(\.id).contains(id)
                }
            case .user:
                if let id = selectedProfiles[.user] {
                    return self.currentCompany.users.map(\.id).contains(id)
                }
        }

        return false
    }

    func profileIsCurrent(_ type: UserTypeDeprecated, id: UUID) -> Bool {
        switch type {
            case .teacher: self.profilesInUse[.teacher] == id
            case .user: self.profilesInUse[.user] == id
        }
    }

    func profileIsAssigned(_ type: UserTypeDeprecated) -> Bool {
        switch type {
            case .teacher:
                if let id = selectedProfiles[.teacher] {
                    return self.currentCompany.teachers.map(\.id).contains(id)
                }
            case .user:
                if let id = selectedProfiles[.user] {
                    return self.currentCompany.users.map(\.id).contains(id)
                }
        }

        return false
    }

    func selectionSetIsCorrect() -> Bool {
        if let teacher = selectedProfiles[.teacher], let user = selectedProfiles[.user] {
            return self.currentCompany.teachers.map(\.id).contains(teacher)
                && self.currentCompany.users.map(\.id).contains(user)
        }

        return false
    }

    func editProfile(_ type: UserTypeDeprecated) {
        switch type {
            case .teacher:
                if let i = currentCompany.teachers.firstIndex(where: { $0.id == selectedProfiles[.teacher] }) {
                    self.bufferTeacher = self.currentCompany.teachers[i]
                }
            case .user:
                if let i = currentCompany.users.firstIndex(where: { $0.id == selectedProfiles[.user] }) {
                    self.bufferUser = self.currentCompany.users[i]
                }
        }
        self.editingProfile = true
    }

    func setBufferAvatar(_ img: String, for type: UserTypeDeprecated) {
        switch type {
            case .teacher: self.bufferTeacher.avatar = img
            case .user: self.bufferUser.avatar = img
        }
    }

    func resetBufferAvatar(_ type: UserTypeDeprecated) {
        switch type {
            case .teacher: self.bufferTeacher.avatar = ""
            case .user: self.bufferUser.avatar = ""
        }
    }

    func saveProfileChanges(_ type: UserTypeDeprecated) {
        switch type {
            case .teacher:
                if let i = currentCompany.teachers.firstIndex(where: { $0.id == bufferTeacher.id }) {
                    self.currentCompany.teachers[i] = self.bufferTeacher
                } else {
                    self.addTeacherProfile()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    self.resetBufferProfile(.teacher)
                }

            case .user:
                if let i = currentCompany.users.firstIndex(where: { $0.id == bufferUser.id }) {
                    self.currentCompany.users[i] = self.bufferUser
                } else {
                    self.addUserProfile()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    self.resetBufferProfile(.user)
                }
        }
        self.editingProfile = false
    }

    func addTeacherProfile() {
        if self.bufferTeacher.avatar == DesignKitAsset.Avatars.accompanyingWhite.name {
            self.bufferTeacher.avatar = DesignKitAsset.Avatars.accompanyingBlue.name
        }
        self.currentCompany.teachers.insert(self.bufferTeacher, at: 0)
        self.selectedProfiles[.teacher] = self.bufferTeacher.id
    }

    func addUserProfile() {
        if self.bufferUser.avatar == DesignKitAsset.Avatars.userWhite.name {
            self.bufferUser.avatar = DesignKitAsset.Avatars.userBlue.name
        }
        self.currentCompany.users.insert(self.bufferUser, at: 0)
        self.selectedProfiles[.user] = self.bufferUser.id
    }

    func deleteProfile(_ type: UserTypeDeprecated) {
        switch type {
            case .teacher:
                self.currentCompany.teachers.removeAll(where: { self.bufferTeacher.id == $0.id })
                self.profilesInUse[.teacher] = UUID()
                self.selectedProfiles[.teacher] = UUID()
                self.editingProfile = false

            case .user:
                self.currentCompany.users.removeAll(where: { self.bufferUser.id == $0.id })
                self.profilesInUse[.user] = UUID()
                self.selectedProfiles[.user] = UUID()
                self.editingProfile = false
        }
    }

    // MARK: - DiscoveryMode

    func setupDiscoveryCompany() {
        self.currentCompany = DiscoveryCompany().discoveryCompany
        self.profilesInUse[.teacher] = self.currentCompany.teachers[0].id
        self.profilesInUse[.user] = self.currentCompany.users[0].id
    }
}
