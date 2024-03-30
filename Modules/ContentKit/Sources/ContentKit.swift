// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LogKit
import Yams

let log = LogKit.createLoggerFor(module: "ContentKit")

// MARK: - ContentKit

public enum ContentKit {
    // MARK: Public

    public static let allActivities: [Activity] = ContentKit.listAllActivities() ?? []
    public static let curriculumList: [Curriculum] = ContentKit.listSampleCurriculums() ?? []

    public static func listImagesPNG() -> [String] {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "png", inDirectory: nil)

        return files
    }

    // MARK: Private

    private static func listSampleCurriculums() -> [Curriculum]? {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "curriculum.yml", inDirectory: nil)

        var curriculums: [Curriculum] = []

        for file in files {
            let data = try? String(contentsOfFile: file, encoding: .utf8)

            guard let data else {
                log.error("Error reading file: \(file)")
                continue
            }

            let curriculum = try? YAMLDecoder().decode(Curriculum.self, from: data)

            guard let curriculum else {
                log.error("Error decoding file: \(file)")
                continue
            }

            curriculums.append(curriculum)
        }

        return curriculums.sorted { $0.name < $1.name }
    }

    private static func listAllActivities() -> [Activity]? {
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

        return activities
    }
}
