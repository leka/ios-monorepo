// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LogKit
import SwiftUI

let log = LogKit.createLoggerFor(app: "LogKitExample")

// MARK: - LogKitExample

@main
struct LogKitExample: App {
    let module = NewModule()

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    self.module.doSomething()
                }
        }
    }
}
