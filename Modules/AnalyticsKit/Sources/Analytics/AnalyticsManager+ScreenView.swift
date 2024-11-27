// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseAnalytics
import SwiftUI

public extension AnalyticsManager {
    static func logEventScreenView(screenName: String, screenClass: String? = nil, parameters: [String: Any] = [:]) {
        var params: [String: Any] = [
            AnalyticsParameterScreenName: screenName,
        ].merging(parameters) { _, new in new }

        if let screenClass {
            params[AnalyticsParameterScreenClass] = screenClass
        }

        logEvent(.screenView, parameters: params)
    }

    enum ScreenViewContext {
        case splitView
        case sheet
        case fullScreenCover
        case context(String)
        case none
        case additionalInfo(String)

        // MARK: Internal

        var description: String {
            switch self {
                case .splitView:
                    "main_splitview"
                case .sheet:
                    "main_sheet"
                case .fullScreenCover:
                    "main_fullscreen"
                case let .context(value):
                    "\(value)"
                case .none:
                    "none"
                case let .additionalInfo(value):
                    "\(value)"
            }
        }

        static func + (lhs: Self, rhs: Self) -> ScreenViewContext {
            .additionalInfo("\(lhs.description)-\(rhs.description)")
        }
    }
}

// MARK: - AnalyticsLogScreenViewViewModifier

struct AnalyticsLogScreenViewViewModifier: ViewModifier {
    // MARK: Lifecycle

    init(
        screenName: String,
        screenClass: String,
        context: AnalyticsManager.ScreenViewContext? = nil,
        parameters: [String: Any] = [:]
    ) {
        self.screenName = screenName
        self.screenClass = screenClass
        self.context = context
        self.parameters = parameters
    }

    // MARK: Internal

    let screenName: String
    let screenClass: String
    let context: AnalyticsManager.ScreenViewContext?
    let parameters: [String: Any]

    func body(content: Content) -> some View {
        content
            .onAppear {
                let screenName = "\(screenName)"
                let params: [String: Any] = [
                    "lk_context": context?.description ?? NSNull(),
                ].merging(self.parameters) { _, new in new }

                AnalyticsManager.logEventScreenView(screenName: screenName, screenClass: self.screenClass, parameters: self.parameters)
            }
    }
}

public extension View {
    func logEventScreenView(
        screenName: String,
        context: AnalyticsManager.ScreenViewContext?,
        screenClass: String? = nil,
        parameters: [String: Any] = [:]
    ) -> some View {
        self.modifier(
            AnalyticsLogScreenViewViewModifier(
                screenName: screenName,
                screenClass: screenClass ?? String(describing: type(of: self)),
                context: context,
                parameters: parameters
            )
        )
    }
}

// MARK: - MyCustomView

#Preview {
    struct MyCustomView: View {
        @State private var isPresented = true

        var body: some View {
            VStack {
                Text("My Custom View")
            }
            .sheet(isPresented: $isPresented) {
                MyCustomSheet()
                    .logEventScreenView(screenName: "my_custom_sheet")
            }
        }

        struct MyCustomSheet: View {
            var body: some View {
                Text("My Custom Sheet")
            }
        }
    }

    return MyCustomView()
        .logEventScreenView(screenName: "my_custom_view")
}
