// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    static func setDefaultEventParameterRootOwnerUid(_ uid: String?) {
        setDefaultEventParameter(for: .rootOwnerUid(uid))
    }

    static func setDefaultEventParameterCaregiverUid(_ uid: String?) {
        setDefaultEventParameter(for: .caregiverUid(uid))
    }

    static func clearDefaultEventParameters() {
        Analytics.setDefaultEventParameters(nil)
    }
}
