// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

public extension ContentKit {
    // TODO(@ladislas): maybe return optional activity instead of fatalError
    static func decodeActivity(_ filename: String) -> Activity {
        do {
            guard let file = Bundle.main.path(forResource: filename, ofType: "yml") else {
                logCK.error("File not found: \(filename)")
                fatalError("💥 File not found: \(filename)")
            }

            let data = try String(contentsOfFile: file, encoding: .utf8)
            let activity = try YAMLDecoder().decode(Activity.self, from: data)

            return activity
        } catch {
            logCK.error("Error decoding \(filename): \(error)")
            fatalError("💥 Error decoding \(filename): \(error)")
        }
    }
}
