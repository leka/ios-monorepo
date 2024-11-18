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

    public func configure(with plist: String) {
        guard let plistPath = Bundle.main.path(forResource: plist, ofType: "plist"),
              let options = FirebaseOptions(contentsOfFile: plistPath)
        else {
            log.critical("\(plist).plist is missing!")
            fatalError("\(plist).plist is missing!")
        }

        log.warning("Firebase: \(plist)")
        log.warning("Firebase options: \(options)")

        FirebaseConfiguration.shared.setLoggerLevel(.min)

        FirebaseApp.configure(options: options)
    }

    // MARK: Private
}
