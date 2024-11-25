// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    static func setUserID(_ userID: String?) {
        Analytics.setUserID(userID)
    }

    static func setUserPropertyUserIsLoggedIn(value: Bool) {
        setUserProperty(value: value.description, forName: "user_is_logged_in")
    }

    // TODO: (@ladislas) fix property length being too long
    static func setUserPropertyCaregiverProfessions(values: [String]) {
        let professions = values.joined(separator: ",")

        setUserProperty(value: professions, forName: "caregiver_professions")
    }

    static func setUserPropertyUserRobotIsConnected(value: Bool) {
        setUserProperty(value: value.description, forName: "robot_is_connected")
    }
}
