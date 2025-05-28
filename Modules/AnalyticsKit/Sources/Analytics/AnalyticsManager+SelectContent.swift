// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics

// MARK: - AnalyticsManager.ContentType

public extension AnalyticsManager {
    enum ContentType: String {
        case curriculum
        case curation
        case activity
        case story
        case resourceFile
        case resourceVideo
    }
}

public extension AnalyticsManager {
    static func logEventSelectContent(
        type: ContentType,
        id: String,
        name: String,
        origin: String?,
        parameters: [String: Any] = [:]
    ) {
        let params: [String: Any] = [
            AnalyticsParameterItemID: "\(name)-\(id)",
            AnalyticsParameterContentType: type.rawValue,
            "lk_content_origin": origin ?? "other",
        ].merging(parameters) { _, new in new }

        logEvent(.selectContent, parameters: params)
    }
}
