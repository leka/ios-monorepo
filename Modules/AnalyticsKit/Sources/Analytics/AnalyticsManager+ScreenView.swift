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

        // MARK: Internal

        var description: String {
            switch self {
                case .splitView:
                    "splitview"
                case .sheet:
                    "sheet"
                case .fullScreenCover:
                    "fullscreen"
                case let .context(value):
                    "\(value)"
            }
        }
    }
}

// MARK: - AnalyticsLogScreenViewViewModifier

struct AnalyticsLogScreenViewViewModifier: ViewModifier {
    // MARK: Lifecycle

    init(
        screenClass: String,
        screenName: String,
        context: AnalyticsManager.ScreenViewContext? = nil,
        parameters: [String: Any] = [:]
    ) {
        self.screenName = screenName
        self.screenClass = screenClass
        self.context = context
        self.parameters = parameters
    }

    // MARK: Internal

    let screenClass: String
    let screenName: String
    let context: AnalyticsManager.ScreenViewContext?
    let parameters: [String: Any]

    func body(content: Content) -> some View {
        content
            .onAppear {
                let params: [String: Any] = [
                    "lk_context": context?.description ?? NSNull(),
                ].merging(self.parameters) { _, new in new }

                AnalyticsManager.logEventScreenView(screenName: self.screenName, screenClass: self.screenClass, parameters: params)
            }
    }
}

public extension View {
    func logEventScreenView(
        screenClass: String? = nil,
        screenName: String,
        context: AnalyticsManager.ScreenViewContext? = nil,
        parameters: [String: Any] = [:]
    ) -> some View {
        self.modifier(
            AnalyticsLogScreenViewViewModifier(
                screenClass: screenClass ?? String(describing: type(of: self)),
                screenName: screenName,
                context: context,
                parameters: parameters
            )
        )
    }
}

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
