// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    func setDefaultEventParameterRootOwnerUid(_ id: String?) {
        self.setDefaultEventParameters(["lk_default_root_owner_uid": id ?? "(lk_not_set)"])
    }

    func setDefaultEventParameterCaregiverUid(_ id: String?) {
        self.setDefaultEventParameters(["lk_default_caregiver_uid": id ?? "(lk_not_set)"])
    }

    func clearDefaultEventParameters() {
        self.setDefaultEventParameters(nil)
    }

    // MARK: Private

    private func setDefaultEventParameters(_ parameters: [String: Any]?) {
        Analytics.setDefaultEventParameters(parameters)
    }
}
