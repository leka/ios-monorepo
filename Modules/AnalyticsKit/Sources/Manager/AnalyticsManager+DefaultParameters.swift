// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    static func setDefaultEventParameterRootOwnerUid(_ id: String?) {
        self.setDefaultEventParameters(["lk_default_root_owner_uid": id ?? "(lk_not_set)"])
    }

    static func setDefaultEventParameterCaregiverUid(_ id: String?) {
        self.setDefaultEventParameters(["lk_default_caregiver_uid": id ?? "(lk_not_set)"])
    }

    static func clearDefaultEventParameters() {
        self.setDefaultEventParameters(nil)
    }

    // MARK: Private

    private static func setDefaultEventParameters(_ parameters: [String: Any]?) {
        Analytics.setDefaultEventParameters(parameters)
    }
}
