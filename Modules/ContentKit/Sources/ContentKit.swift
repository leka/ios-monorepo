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
    public static let allPublishedActivities: [Activity] = ContentKit.listAllPublishedActivities() ?? []
    public static let allDraftActivities: [Activity] = ContentKit.listAllDraftActivities() ?? []
    public static let allTemplateActivities: [Activity] = ContentKit.listAllTemplateActivities() ?? []
    public static let allCurriculums: [Curriculum] = ContentKit.listCurriculums() ?? []
    public static let allStories: [Story] = ContentKit.listAllStories() ?? []

    public static func listRasterImages() -> [String] {
        let bundle = Bundle.module
        var files: [String] = []

        files.append(contentsOf: bundle.paths(forResourcesOfType: "png", inDirectory: nil))
        files.append(contentsOf: bundle.paths(forResourcesOfType: "jpg", inDirectory: nil))
        files.append(contentsOf: bundle.paths(forResourcesOfType: "jpeg", inDirectory: nil))

        return files.sorted()
    }

    public static func listVectorImages() -> [String] {
        let bundle = Bundle.module
        var files: [String] = []

        files.append(contentsOf: bundle.paths(forResourcesOfType: "svg", inDirectory: nil))

        return files.sorted()
    }

    // MARK: Private

    private static func listCurriculums() -> [Curriculum]? {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "curriculum.yml", inDirectory: nil)

        var curriculums: [Curriculum] = []

        for file in files {
            let data = try? String(contentsOfFile: file, encoding: .utf8)

            guard let data else {
                log.error("Error reading file: \(file)")
                continue
            }

            do {
                let curriculum = try YAMLDecoder().decode(Curriculum.self, from: data)
                curriculums.append(curriculum)
            } catch {
                log.error("Error decoding file: \(file) with error:\n\(error)")
            }
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

            do {
                let activity = try YAMLDecoder().decode(Activity.self, from: data)
                activities.append(activity)
            } catch {
                log.error("Error decoding file: \(file) with error:\n\(error)")
            }
        }

        return activities
    }

    private static func listAllPublishedActivities() -> [Activity]? {
        self.allActivities.filter { $0.status == .published }
    }

    private static func listAllDraftActivities() -> [Activity]? {
        self.allActivities.filter { $0.status == .draft }
    }

    private static func listAllTemplateActivities() -> [Activity]? {
        self.allActivities.filter { $0.status == .template }
    }

    private static func listAllStories() -> [Story]? {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "story.yml", inDirectory: nil)

        var stories: [Story] = []

        for file in files {
            let data = try? String(contentsOfFile: file, encoding: .utf8)

            guard let data else {
                log.error("Error reading file: \(file)")
                continue
            }

            do {
                let story = try YAMLDecoder().decode(Story.self, from: data)
                stories.append(story)
            } catch {
                log.error("Error decoding file: \(file) with error:\n\(error)")
            }
        }

        return stories
    }
}
