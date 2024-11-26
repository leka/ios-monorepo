// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics
import Foundation

public extension AnalyticsManager {
    static func logEventCaregiverSelect(from previous: String?, to new: String, parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "lk_caregiver_id_previous": previous ?? NSNull(),
            "lk_caregiver_id_new": new,
        ].merging(parameters) { _, new in new }

        logEvent(.caregiverSelect, parameters: params)
    }

    static func logEventCarereceiverSkipSelect(parameters: [String: Any] = [:]) {
        let params: [String: Any] = [:].merging(parameters) { _, new in new }

        logEvent(.carereceiverSkipSelect, parameters: params)
    }
}