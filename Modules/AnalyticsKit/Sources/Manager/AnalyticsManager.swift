// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import FirebaseAnalytics

public class AnalyticsManager {
    // MARK: Lifecycle

    private init() {
        // Nothing to do
    }

    // MARK: Public

    public enum ContentType: String {
        case curriculum
        case activity
        case educationalGame = "educational_game"
        case story
        case gamepad
        case resource
    }

    public enum ContentOrigin: String {
        case generalLibrary = "general_library"
        case personalLibrary = "personal_library"
        case searchResults = "search_results"
        case resourcesFirstSteps = "resources_first_steps"
        case resourcesVideos = "resources_videos"
        case resourcesDeepDive = "resources_deep_dive"
    }

    public static let shared = AnalyticsManager()

    // MARK: Public Methods

    public func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }

    public func logEventScreenView(screenName: String, screenClass: String? = nil) {
        var params: [String: Any] = [
            AnalyticsParameterScreenName: screenName,
        ]

        if let screenClass {
            params[AnalyticsParameterScreenClass] = screenClass
        }

        Analytics.logEvent(AnalyticsEventScreenView, parameters: params)
    }

    public func setDefaultEventParameters(_ parameters: [String: Any]?) {
        Analytics.setDefaultEventParameters(parameters)
    }

    public func clearDefaultEventParameters() {
        self.setDefaultEventParameters(nil)
    }

    public func logEventSelectContent(
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
