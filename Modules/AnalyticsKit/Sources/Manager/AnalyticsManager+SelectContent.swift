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
        case resourceFile
        case resourceVideo
    }

    enum ContentOrigin: String {
        case generalLibrary = "general_library"
        case personalLibrary = "personal_library"
        case searchResults = "search_results"
        case resources
    }
}

public extension AnalyticsManager {
    static func logEventSelectContent(
        type: ContentType,
        id: String,
        name: String,
        origin: ContentOrigin,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            AnalyticsParameterItemID: "\(name)-\(id)",
            AnalyticsParameterContentType: type.rawValue,
            "lk_content_origin": origin.rawValue,
        ].merging(parameters) { _, new in new }

        logEvent(.selectContent, parameters: params)
    }
}
