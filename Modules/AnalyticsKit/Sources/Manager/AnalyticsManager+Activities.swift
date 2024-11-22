// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    enum ActivityEndReason: String {
        case activityCompleted = "activity_completed"
        case userExited = "user_exited"
    }

    func logEventActivityStart(id: String, name: String, carereceiverIDs: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_activity_id": "\(name)-\(id)",
            "lk_carereceiver_ids": carereceiverIDs,
        ].merging(parameters) { _, new in new }

        self.logEvent(name: "activity_start", parameters: params)
    }

    func logEventActivityEnd(
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

        self.logEvent(name: "activity_end", parameters: params)
    }
}
