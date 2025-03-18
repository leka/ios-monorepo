// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    enum ActivityLaunchOrigin: String {
        case detailsViewButton = "details_view_button"
        case listButton = "list_button"
    }

    static func logEventActivityLaunch(
        id: String,
        name: String,
        origin: ActivityLaunchOrigin,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_activity_launch_origin": origin.rawValue,
        ].merging(parameters) { _, new in new }

        logEvent(.activityLaunch, parameters: params)
    }
}

public extension AnalyticsManager {
    enum ActivityEndReason: String {
        case activityCompleted = "activity_completed"
        case userExited = "user_exited"
    }

    static func logEventActivityStart(id: String, name: String, carereceiverIDs: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_carereceiver_ids": carereceiverIDs,
        ].merging(parameters) { _, new in new }

        logEvent(.activityStart, parameters: params)
    }

    static func logEventActivityEnd(
        id: String,
        name: String,
        carereceiverIDs: String,
        reason: ActivityEndReason,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_carereceiver_ids": carereceiverIDs,
            "lk_activity_end_reason": reason.rawValue,
        ].merging(parameters) { _, new in new }

        logEvent(.activityEnd, parameters: params)
    }
}
