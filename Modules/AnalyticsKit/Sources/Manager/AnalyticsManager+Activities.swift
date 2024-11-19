// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    enum ActivityEndReason: String {
        case userCompleted = "user_completed"
        case userExited = "user_exited"
    }

    func logEventActivityStart(id: String, name: String, carereceiverIDs: String) {
        Analytics.logEvent("activity_start", parameters: [
            "lk_activity_id": "\(name)-\(id)",
            "lk_carereceiver_ids": carereceiverIDs,
        ])
    }

    func logEventActivityEnd(
        id: String,
        name: String,
        carereceiverIDs: String,
        reason: ActivityEndReason
    ) {
        Analytics.logEvent("activity_end", parameters: [
            "lk_activity_id": "\(name)-\(id)",
            "lk_carereceiver_ids": carereceiverIDs,
            "lk_activity_end_reason": reason.rawValue,
        ])
    }
}
