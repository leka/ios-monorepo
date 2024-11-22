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

        Self.logEvent(.screenView, parameters: params)
    }
}

public extension View {
    func logEventScreenView(screenName: String, screenClass: String? = nil, parameters: [String: Any] = [:]) -> some View {
        let screenClass = screenClass ?? String(describing: type(of: self))
        return self.onAppear {
            AnalyticsManager.logEventScreenView(screenName: screenName, screenClass: screenClass, parameters: parameters)
        }
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
