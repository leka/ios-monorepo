// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseCore
import LogKit

let log = LogKit.createLoggerFor(module: "FirebaseKit")

// MARK: - FirebaseKit

public class FirebaseKit {
    // MARK: Lifecycle

    private init() {}

    // MARK: Public

    public static let shared = FirebaseKit()

    public func configure() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
}
