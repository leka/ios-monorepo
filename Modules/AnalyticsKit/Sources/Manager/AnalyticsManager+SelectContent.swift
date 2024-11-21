// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

public extension AnalyticsManager {
    enum ContentType: String {
        case curriculum
        case activity
        case educationalGame = "educational_game"
        case story
        case gamepad
        case resource
    }

    enum ContentOrigin: String {
        case generalLibrary = "general_library"
        case personalLibrary = "personal_library"
        case searchResults = "search_results"
        case resourcesFirstSteps = "resources_first_steps"
        case resourcesVideos = "resources_videos"
        case resourcesDeepDive = "resources_deep_dive"
    }
}

public extension AnalyticsManager {
    func logEventSelectContent(
        type: ContentType,
        id: String,
        name: String,
        origin: ContentOrigin,
        additionalParameters: [String: Any]? = nil
    ) {
        var parameters: [String: Any] = [
            AnalyticsParameterItemID: "\(name)-\(id)",
            AnalyticsParameterContentType: type.rawValue,
            "lk_content_origin": origin.rawValue,
        ]

        if let additionalParameters {
            parameters.merge(additionalParameters) { _, new in new }
        }

        Analytics.logEvent(AnalyticsEventSelectContent, parameters: parameters)
    }
}
