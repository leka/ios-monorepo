// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func logEventCaregiverSelect(id: String?) {
        Analytics.logEvent("caregiver_select", parameters: [
            "lk_caregiver_id": id ?? "(lk_not_set)",
        ])
    }

    func logEventCarereceiverSkipSelect() {
        Analytics.logEvent("carereceiver_skip_select", parameters: nil)
    }
}
