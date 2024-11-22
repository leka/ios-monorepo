// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    static func logEventCaregiverSelect(id: String?, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_caregiver_id": id ?? "(lk_not_set)",
        ].merging(parameters) { _, new in new }

        Self.logEvent(name: "caregiver_select", parameters: params)
    }

    static func logEventCarereceiverSkipSelect(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        Self.logEvent(name: "carereceiver_skip_select", parameters: params)
    }
}
