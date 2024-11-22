// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    // TODO: (@ladislas) add real versions
    func logEventAppUpdateSkip(currentVersion: String = "(lk_not_set)", newVersion: String = "(lk_not_set)", parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "current_version": currentVersion,
            "new_version": newVersion,
        ].merging(parameters) { _, new in new }

        self.logEvent(name: "app_update_skip", parameters: params)
    }

    // TODO: (@ladislas) add real versions
    func logEventAppUpdateOpenAppStore(currentVersion: String = "(lk_not_set)", newVersion: String = "(lk_not_set)", parameters: [String: Any] = [:]) {
        let params: [String: Any] = [
            "current_version": currentVersion,
            "new_version": newVersion,
        ].merging(parameters) { _, new in new }

        self.logEvent(name: "app_update_open_app_store", parameters: params)
    }
}
