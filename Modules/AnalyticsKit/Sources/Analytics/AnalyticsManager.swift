// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAnalytics
import Foundation
import Logging

public class AnalyticsManager {
    // MARK: Lifecycle

    private init() {
        // Nothing to do
    }

    // MARK: Internal

    enum DefaultEventParamters {
        case rootOwnerUid(String?)
        case caregiverUid(String?)
    }

    enum Event {
        case activityLaunch
        case activityStart
        case activityEnd

        case appUpdateAlertResponse
        case osUpdateAlertResponse

        case login
        case logout
        case signup
        case skipAuthentication
        case accountDelete

        case screenView

        case robotConnect
        case robotDisconnect
        case robotRename

        case selectContent

        case caregiverCreate
        case caregiverSelect
        case caregiverEdit

        case carereceiverCreate
        case carereceiverEdit
        case carereceiversSelect
        case carereceiverSkipSelect

        case sharedLibraryAddActivity
        case sharedLibraryRemoveActivity
        case sharedLibraryAddCurriculum
        case sharedLibraryRemoveCurriculum
        case sharedLibraryAddStory
        case sharedLibraryRemoveStory

        // MARK: Internal

        var name: String {
            switch self {
                case .activityLaunch:
                    "activity_launch"
                case .activityStart:
                    "activity_start"
                case .activityEnd:
                    "activity_end"

                case .appUpdateAlertResponse:
                    "app_update_alert_response"
                case .osUpdateAlertResponse:
                    "os_update_alert_response"

                case .login:
                    AnalyticsEventLogin // ? "login"
                case .logout:
                    "logout"
                case .signup:
                    AnalyticsEventSignUp // ? "sign_up"
                case .skipAuthentication:
                    "skip_authentication"
                case .accountDelete:
                    "account_delete"

                case .screenView:
                    AnalyticsEventScreenView // ? "screen_view"

                case .robotConnect:
                    "robot_connect"
                case .robotDisconnect:
                    "robot_disconnect"
                case .robotRename:
                    "robot_rename"

                case .selectContent:
                    AnalyticsEventSelectContent // ? "select_content"

                case .caregiverCreate:
                    "caregiver_create"
                case .caregiverSelect:
                    "caregiver_select"
                case .caregiverEdit:
                    "caregiver_edit"

                case .carereceiverCreate:
                    "carereceiver_create"
                case .carereceiverEdit:
                    "carereceiver_edit"
                case .carereceiversSelect:
                    "carereceivers_select"
                case .carereceiverSkipSelect:
                    "carereceiver_skip_select"

                case .sharedLibraryAddActivity:
                    "shared_library_add_activity"
                case .sharedLibraryRemoveActivity:
                    "shared_library_remove_activity"
                case .sharedLibraryAddCurriculum:
                    "shared_library_add_curriculum"
                case .sharedLibraryRemoveCurriculum:
                    "shared_library_remove_curriculum"
                case .sharedLibraryAddStory:
                    "shared_library_add_story"
                case .sharedLibraryRemoveStory:
                    "shared_library_remove_story"
            }
        }
    }

    struct AnalyticsError {
        // MARK: Lifecycle

        init(domain: Domain, code: Int, message: String) {
            self.domain = domain
            self.code = code
            self.message = "\(message)"
        }

        // MARK: Internal

        enum Domain: String {
            case event
            case userProperty
        }

        let message: Logger.Message
        let domain: Domain
        let code: Int

        var error: NSError {
            NSError(
                domain: "app.leka.error.analytics.\(self.domain)",
                code: self.code,
                userInfo: [NSLocalizedDescriptionKey: self.message.description]
            )
        }
    }

    static func logEvent(_ event: Event, parameters: [String: Any] = [:]) {
        if event.name.isEmpty {
            let error = AnalyticsError(domain: .event, code: 0, message: "Event name is empty: \(event)")
            log.error(error.message)
            CrashlyticsManager.recordError(error.error)
        }

        if event.name.count > 40 {
            let error = AnalyticsError(domain: .event, code: 1, message: "Event name is too long: \(event) - (\(event.name.count) characters)")
            log.error(error.message)
            CrashlyticsManager.recordError(error.error)
        }

        let kAuthorizedKeys: [String] = ["screen_class", "screen_name", "content_type", "item_id"]

        for (key, value) in parameters {
            if key.isEmpty {
                let error = AnalyticsError(domain: .event, code: 2, message: "Event parameter key is empty: \(event)")
                log.error(error.message)
                CrashlyticsManager.recordError(error.error)
            }

            if key.count > 40 {
                let error = AnalyticsError(domain: .event, code: 3, message: "Event parameter key too long: \(event) - \(key) - (\(key.count) characters)")
                log.error(error.message)
                CrashlyticsManager.recordError(error.error)
            }

            if "\(value)".count > 100 {
                let error = AnalyticsError(domain: .event, code: 4, message: "Event parameter value too long: \(event) - \(key) - \(value) - (\("\(value)".count) characters)")
                log.error(error.message)
                CrashlyticsManager.recordError(error.error)
            }

            if !key.starts(with: "lk_"), !kAuthorizedKeys.contains(key) {
                let error = AnalyticsError(domain: .event, code: 5, message: "Event parameter key missing prefix 'lk_': \(event) - \(key)")
                log.error(error.message)
                CrashlyticsManager.recordError(error.error)
                CrashlyticsManager.recordError(error.error)
            }
        }

        Analytics.logEvent(event.name, parameters: parameters)
    }

    static func setUserProperty(value: String, forName name: String) {
        if name.isEmpty {
            let error = AnalyticsError(domain: .userProperty, code: 0, message: "User property name is empty")
            log.error(error.message)
            CrashlyticsManager.recordError(error.error)
        }

        if name.count > 24 {
            let error = AnalyticsError(domain: .userProperty, code: 1, message: "User property name is too long: \(name) - (\(name.count) characters)")
            log.error(error.message)
            CrashlyticsManager.recordError(error.error)
        }

        if value.count > 36 {
            let error = AnalyticsError(domain: .userProperty, code: 2, message: "User property value is too long: \(name) - \(value) - (\(value.count) characters)")
            log.error(error.message)
            CrashlyticsManager.recordError(error.error)
        }

        Analytics.setUserProperty(value, forName: name)
    }

    static func setDefaultEventParameter(for parameter: DefaultEventParamters) {
        switch parameter {
            case let .rootOwnerUid(uid):
                Analytics.setDefaultEventParameters(["lk_default_root_owner_uid": uid ?? NSNull()])
            case let .caregiverUid(uid):
                Analytics.setDefaultEventParameters(["lk_default_caregiver_id": uid ?? NSNull()])
        }
    }
}
