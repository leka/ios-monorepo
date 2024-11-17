// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func logEventCaregiverSelect() {
        Analytics.logEvent("caregiver_select", parameters: nil)
    }

    func logEventCarereceiverSkipSelect() {
        Analytics.logEvent("carereceiver_skip_select", parameters: nil)
    }
}
