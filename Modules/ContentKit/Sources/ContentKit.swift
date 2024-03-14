// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LogKit
import Yams

let log = LogKit.createLoggerFor(module: "ContentKit")

// MARK: - ContentKit

public enum ContentKit {
    public static func listSampleActivities() -> [Activity]? {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "activity.yml", inDirectory: nil)

        var activities: [Activity] = []

        for file in files {
            let data = try? String(contentsOfFile: file, encoding: .utf8)

            guard let data else {
                log.error("Error reading file: \(file)")
                continue
            }

            let activity = try? YAMLDecoder().decode(Activity.self, from: data)

            guard let activity else {
                log.error("Error decoding file: \(file)")
                continue
            }

            activities.append(activity)
        }

        return activities.sorted { $0.name < $1.name }
    }

    public static func listImagesPNG() -> [String] {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "png", inDirectory: nil)

        return files
    }
}
