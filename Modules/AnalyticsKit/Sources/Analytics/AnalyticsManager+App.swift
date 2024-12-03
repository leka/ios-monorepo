// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    enum AppUpdateAlertResponseAction: String {
        case remindLater = "remind_later"
        case openAppStore = "open_app_store"
    }

    static func logEventAppUpdateAlertResponse(
        _ action: AppUpdateAlertResponseAction,
        currentVersion _: String = "", // TODO: (@ladislas) add current/new versions
        newVersion _: String = "",
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_app_version_current": NSNull(),
            "lk_app_version_update": NSNull(),
            "lk_response_action": action.rawValue,
        ].merging(parameters) { _, new in new }

        logEvent(.appUpdateAlertResponse, parameters: params)
    }

    enum OSUpdateAlertResponseAction: String {
        case remindLater = "remind_later"
        case openSettings = "open_settings"
    }

    static func logEventOSUpdateAlertResponse(
        _ action: OSUpdateAlertResponseAction,
        currentVersion _: String = "", // TODO: (@ladislas) add current/new versions
        newVersion _: String = "",
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            "lk_os_version_current": NSNull(),
            "lk_os_version_update": NSNull(),
            "lk_response_action": action.rawValue,
        ].merging(parameters) { _, new in new }

        logEvent(.osUpdateAlertResponse, parameters: params)
    }
}
