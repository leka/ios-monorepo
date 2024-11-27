// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAnalytics

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
        case activityStart
        case activityEnd

        case appUpdateSkip
        case appUpdateOpenAppStore

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

        case carereceiverSkipSelect

        // MARK: Internal

        var name: String {
            switch self {
                case .activityStart:
                    "activity_start"
                case .activityEnd:
                    "activity_end"

                case .appUpdateSkip:
                    "app_update_skip"
                case .appUpdateOpenAppStore:
                    "app_update_open_app_store"

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

                case .carereceiverSkipSelect:
                    "carereceiver_skip_select"
            }
        }
    }

    static func logEvent(_ event: Event, parameters: [String: Any] = [:]) {
        Analytics.logEvent(event.name, parameters: parameters)
    }

    static func setUserProperty(value: String, forName name: String) {
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
