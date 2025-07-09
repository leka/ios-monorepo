// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import Combine
import ContentKit
import SwiftUI

final class DatabaseAnalyticsEventBridge {
    // MARK: Lifecycle

    private init() {
        // Nothing to do
    }

    // MARK: Public

    public func subscribeToDatabaseEvents() {
        self.subscribeToAuthEvents()
        self.subscribeToCaregiverEvents()
        self.subscribeToCarereceiverEvents()
        self.subscribeToSharedLibraryEvents()
    }

    // MARK: Internal

    static let shared = DatabaseAnalyticsEventBridge()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private func subscribeToSharedLibraryEvents() {
        SharedLibraryManager.shared.eventPublisher
            .sink { [weak self] event in
                self?.handleSharedLibrary(event: event)
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToCaregiverEvents() {
        CaregiverManager.shared.eventPublisher
            .sink { [weak self] event in
                self?.handleCaregiver(event: event)
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToCarereceiverEvents() {
        CarereceiverManager.shared.eventPublisher
            .sink { [weak self] event in
                self?.handleCarereceiver(event: event)
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToAuthEvents() {
        AuthManager.shared.analyticsEvent
            .sink { [weak self] event in
                self?.handleAuth(event: event)
            }
            .store(in: &self.cancellables)
    }

    // swiftlint:disable cyclomatic_complexity function_body_length

    private func handleSharedLibrary(event: SharedLibraryManager.Event) {
        switch event {
            case let .didAddCurriculumToSharedLibrary(payload):
                let name = Curriculum(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryAddCurriculum(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didRemoveCurriculumFromSharedLibrary(payload):
                let name = Curriculum(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryRemoveCurriculum(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didAddCurriculumToFavorites(payload):
                let name = Curriculum(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryAddCurriculumToFavorites(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didRemoveCurriculumFromFavorites(payload):
                let name = Curriculum(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryRemoveCurriculumFromFavorites(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didAddActivityToSharedLibrary(payload):
                let name = Activity(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryAddActivity(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didRemoveActivityFromSharedLibrary(payload):
                let name = Activity(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryRemoveActivity(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didAddActivityToFavorites(payload):
                let name = Activity(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryAddActivityToFavorites(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didRemoveActivityFromFavorites(payload):
                let name = Activity(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryRemoveActivityFromFavorites(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didAddStoryToSharedLibrary(payload):
                let name = Story(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryAddStory(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didRemoveStoryFromSharedLibrary(payload):
                let name = Story(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryRemoveStory(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didAddStoryToFavorites(payload):
                let name = Story(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryAddStoryToFavorites(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )

            case let .didRemoveStoryFromFavorites(payload):
                let name = Story(id: payload.id)?.name ?? "Unknown"
                AnalyticsManager.logEventSharedLibraryRemoveStoryFromFavorites(
                    id: payload.id,
                    name: name,
                    caregiver: payload.caregiverID
                )
        }
    }

    // swiftlint:enable cyclomatic_complexity function_body_length

    private func handleCaregiver(event: CaregiverManager.Event) {
        switch event {
            case let .didCreateCaregiver(id):
                AnalyticsManager.logEventCaregiverCreate(id: id)

            case let .didEditCaregiver(caregiver):
                AnalyticsManager.logEventCaregiverEdit(caregiver: caregiver)

            case let .didSelectCaregiver(previous, new):
                AnalyticsManager.logEventCaregiverSelect(from: previous, to: new)
                AnalyticsManager.setDefaultEventParameterCaregiverUid(new)

                guard let caregiver = CaregiverManager.shared.currentCaregiver.value else { return }
                AnalyticsManager.setUserPropertyCaregiverProfessions(
                    values: caregiver.professions.compactMap { Professions.profession(for: $0)?.sha }
                )

            case .didResetCaregiver:
                AnalyticsManager.setDefaultEventParameterCaregiverUid(nil)
                AnalyticsManager.setUserPropertyCaregiverProfessions(values: [])

            case let .didUpdateCaregiverProperties(professions):
                AnalyticsManager.setUserPropertyCaregiverProfessions(values: professions)
        }
    }

    // swiftlint:disable identifier_name

    private func handleCarereceiver(event: CarereceiverManager.Event) {
        switch event {
            case let .didCreateCarereceiver(id):
                AnalyticsManager.logEventCarereceiverCreate(id: id)

            case let .didUpdateCarereceiver(id):
                AnalyticsManager.logEventCarereceiverEdit(carereceiver: id)

            case let .didSelectCarereceivers(ids):
                AnalyticsManager.logEventCarereceiversSelect(carereceivers: ids)
        }
    }

    private func handleAuth(event: AuthManager.Event) {
        switch event {
            case let .didDetectLoggedInState(uid):
                AnalyticsManager.setUserID(uid)
                AnalyticsManager.setUserPropertyUserIsLoggedIn(value: true)
                AnalyticsManager.setDefaultEventParameterRootOwnerUid(uid)

            case .didDetectLoggedOutState:
                AnalyticsManager.setUserID(nil)
                AnalyticsManager.setUserPropertyUserIsLoggedIn(value: false)
                AnalyticsManager.clearDefaultEventParameters()

            case let .didSignUp(uid):
                AnalyticsManager.setUserID(uid)
                AnalyticsManager.setUserPropertyUserIsLoggedIn(value: true)
                AnalyticsManager.setDefaultEventParameterRootOwnerUid(uid)

            case let .didSignIn(uid):
                AnalyticsManager.setUserID(uid)
                AnalyticsManager.setUserPropertyUserIsLoggedIn(value: true)
                AnalyticsManager.setDefaultEventParameterRootOwnerUid(uid)

            case .didSignOut:
                AnalyticsManager.logEventLogout()
                AnalyticsManager.setUserID(nil)
                AnalyticsManager.setUserPropertyUserIsLoggedIn(value: false)
                AnalyticsManager.clearDefaultEventParameters()

            case .didDeleteAccount:
                AnalyticsManager.logEventAccountDelete()
                AnalyticsManager.setUserID(nil)
                AnalyticsManager.setUserPropertyUserIsLoggedIn(value: false)
                AnalyticsManager.clearDefaultEventParameters()
        }
    }

    // swiftlint:enable identifier_name
}
