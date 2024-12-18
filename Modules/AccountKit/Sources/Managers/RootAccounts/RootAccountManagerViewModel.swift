// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI
import Version

public class RootAccountManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    public init() {
        self.subscribeToManager()
    }

    // MARK: Public

    @Published public var currentRootAccount: RootAccount?
    @Published public var currentConsentInfo: ConsentInfo? // Not published
    @Published public var savedActivities: [SavedActivity] = []
    @Published public var savedCurriculums: [SavedCurriculum] = []
    @Published public var savedStories: [SavedStory] = []
    @Published public var savedGamepads: [SavedGamepad] = []
    @Published public var errorMessage: String = ""
    @Published public var showErrorAlert: Bool = false
    @Published public var isLoading: Bool = false

    // MARK: Activities

    public func addSavedActivity(activityID: String, caregiverID: String) {
        self.rootAccountManager.addSavedActivity(activityID: activityID, caregiverID: caregiverID)
    }

    public func removeSavedActivity(activityID: String) {
        self.rootAccountManager.removeSavedActivity(activityID: activityID)
    }

    public func isActivitySaved(activityID: String) -> Bool {
        self.savedActivities.contains(where: { $0.id == activityID })
    }

    // MARK: Curriculums

    public func addSavedCurriculum(curriculumID: String, caregiverID: String) {
        self.rootAccountManager.addSavedCurriculum(curriculumID: curriculumID, caregiverID: caregiverID)
    }

    public func removeSavedCurriculum(curriculumID: String) {
        self.rootAccountManager.removeSavedCurriculum(curriculumID: curriculumID)
    }

    public func isCurriculumSaved(curriculumID: String) -> Bool {
        self.savedCurriculums.contains(where: { $0.id == curriculumID })
    }

    // MARK: Stories

    public func addSavedStory(storyID: String, caregiverID: String) {
        self.rootAccountManager.addSavedStory(storyID: storyID, caregiverID: caregiverID)
    }

    public func removeSavedStory(storyID: String) {
        self.rootAccountManager.removeSavedStory(storyID: storyID)
    }

    public func isStorySaved(storyID: String) -> Bool {
        self.savedStories.contains(where: { $0.id == storyID })
    }

    // MARK: Gamepads

    public func addSavedGamepad(gamepadID: String, caregiverID: String) {
        self.rootAccountManager.addSavedGamepad(gamepadID: gamepadID, caregiverID: caregiverID)
    }

    public func removeSavedGamepad(gamepadID: String) {
        self.rootAccountManager.removeSavedGamepad(gamepadID: gamepadID)
    }

    public func isGamepadSaved(gamepadID: String) -> Bool {
        self.savedGamepads.contains(where: { $0.id == gamepadID })
    }

    public func resetData() {
        self.rootAccountManager.resetData()
    }

    // ConsentInfo

    public func needsConsentUpdate(latestPolicyVersion: String) -> Bool {
        guard let currentConsent = self.currentConsentInfo,
              let currentVersion = Version(tolerant: currentConsent.policyVersion),
              let latestVersion = Version(tolerant: latestPolicyVersion)
        else {
            return true
        }
        return currentVersion < latestVersion
    }

    public func updateConsentInfo(policyVersion: String) {
        self.rootAccountManager.appendConsentInfo(policyVersion: policyVersion)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let rootAccountManager = RootAccountManager.shared

    private func getLatestConsentInfo(from consentInfo: [ConsentInfo]) -> ConsentInfo? {
        consentInfo.max(by: { consent1, consent2 in
            let version1 = Version(tolerant: consent1.policyVersion) ?? Version("0.0.0")!
            let version2 = Version(tolerant: consent2.policyVersion) ?? Version("0.0.0")!
            return version1 < version2
        })
    }

    private func subscribeToManager() {
        self.rootAccountManager.currentRootAccountPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] rootAccount in
                guard let self, let rootAccount else { return }
                self.currentRootAccount = rootAccount

                let library = rootAccount.library
                self.savedActivities = library.savedActivities
                self.savedCurriculums = library.savedCurriculums
                self.savedStories = library.savedStories
                self.savedGamepads = library.savedGamepads

                self.currentConsentInfo = self.getLatestConsentInfo(from: rootAccount.consentInfo)
            })
            .store(in: &self.cancellables)

        self.rootAccountManager.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                self?.isLoading = isLoading
            })
            .store(in: &self.cancellables)

        self.rootAccountManager.fetchErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                self?.handleError(error)
            })
            .store(in: &self.cancellables)
    }

    private func handleError(_ error: Error) {
        if let databaseError = error as? DatabaseError {
            switch databaseError {
                case let .customError(message):
                    if message == "User not authenticated" {
                        self.errorMessage = "Please log in to continue."
                    } else {
                        self.errorMessage = message
                    }
                case .documentNotFound:
                    self.errorMessage = "The requested data could not be found."
                case .decodeError:
                    self.errorMessage = "There was an error decoding the data."
                case .encodeError:
                    self.errorMessage = "There was an error encoding the data."
            }
        } else {
            self.errorMessage = "An unknown error occurred: \(error.localizedDescription)"
        }
        self.showErrorAlert = true
    }
}
