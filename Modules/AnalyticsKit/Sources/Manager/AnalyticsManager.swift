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

    // MARK: Public

    public static let shared = AnalyticsManager()

    // MARK: Internal

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

                case .caregiverSelect:
                    "caregiver_select"
                case .carereceiverSkipSelect:
                    "carereceiver_skip_select"
            }
        }
    }

    static func logEvent(name: String, parameters: [String: Any] = [:]) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
