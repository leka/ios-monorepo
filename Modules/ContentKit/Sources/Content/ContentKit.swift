// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LogKit
import Yams

let logCK = LogKit.createLoggerFor(module: "ContentKit")

// MARK: - ContentKit

public enum ContentKit {
    // MARK: Public

    public static var allActivities: [String: Activity] = ContentKit.listAllActivities() ?? [:]
    public static let allPublishedActivities: [String: Activity] = ContentKit.listAllPublishedActivities() ?? [:]
    public static let allDraftActivities: [String: Activity] = ContentKit.listAllDraftActivities() ?? [:]
    public static let allTemplateActivities: [String: Activity] = ContentKit.listAllTemplateActivities() ?? [:]
    public static let allCurriculums: [String: Curriculum] = ContentKit.listCurriculums() ?? [:]
    public static let allPublishedCurriculums: [String: Curriculum] = ContentKit.listAllPublishedCurriculums() ?? [:]
    public static let allDraftCurriculums: [String: Curriculum] = ContentKit.listAllDraftCurriculums() ?? [:]
    public static let allTemplateCurriculums: [String: Curriculum] = ContentKit.listAllTemplateCurriculums() ?? [:]
    public static let allStories: [String: Story] = ContentKit.listAllStories() ?? [:]
    public static let allCurations: [String: CategoryCuration] = ContentKit.listAllCurations() ?? [:]
    public static let allResources: [String: CategoryResources] = ContentKit.listAllResources() ?? [:]

    public static func listRasterImages() -> [String] {
        let bundle = Bundle.module
        var files: [String] = []

        files.append(contentsOf: bundle.filenamesWithoutExtensions(forResourcesOfType: "png", inDirectory: nil))
        files.append(contentsOf: bundle.filenamesWithoutExtensions(forResourcesOfType: "jpg", inDirectory: nil))
        files.append(contentsOf: bundle.filenamesWithoutExtensions(forResourcesOfType: "jpeg", inDirectory: nil))

        return files.sorted()
    }

    public static func listVectorImages() -> [String] {
        let bundle = Bundle.module
        var files: [String] = []

        files.append(contentsOf: bundle.filenamesWithoutExtensions(forResourcesOfType: "svg", inDirectory: nil))

        return files.sorted()
    }

    // MARK: Private

    private static func listAllCurations() -> [String: CategoryCuration]? {
        let bundle = Bundle.module
        var curations: [String: CategoryCuration] = [:]
        let paths = bundle.paths(forResourcesOfType: "curation.yml", inDirectory: nil)

        for path in paths {
            let data = try? String(contentsOfFile: path, encoding: .utf8)

            guard let data else {
                logCK.error("Error reading file: \(path)")
                continue
            }

            do {
                let curation = try YAMLDecoder().decode(CategoryCuration.self, from: data)
                curations[curation.id] = curation
            } catch {
                logCK.error("Error decoding file: \(path) with error:\n\(error)")
            }
        }

        return curations
    }

    private static func listCurriculums() -> [String: Curriculum]? {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "curriculum.yml", inDirectory: nil)

        var curriculums: [String: Curriculum] = [:]

        for file in files {
            let data = try? String(contentsOfFile: file, encoding: .utf8)

            guard let data else {
                logCK.error("Error reading file: \(file)")
                continue
            }

            do {
                let curriculum = try YAMLDecoder().decode(Curriculum.self, from: data)

                for activity in curriculum.activities {
                    self.allActivities[activity]?.curriculums.append(curriculum.id)
                }
                curriculums[curriculum.id] = curriculum
            } catch {
                logCK.error("Error decoding file: \(file) with error:\n\(error)")
            }
        }

        return curriculums
    }

    private static func listAllActivities() -> [String: Activity]? {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "activity.yml", inDirectory: nil)

        var activities: [String: Activity] = [:]

        for file in files {
            let data = try? String(contentsOfFile: file, encoding: .utf8)

            guard let data else {
                logCK.error("Error reading file: \(file)")
                continue
            }

            do {
                let activity = try YAMLDecoder().decode(Activity.self, from: data)
                activities[activity.uuid] = activity
            } catch {
                logCK.error("Error decoding file: \(file) with error:\n\(error)")
            }
        }

        return activities
    }

    private static func listAllPublishedActivities() -> [String: Activity]? {
        self.allActivities.filter { $0.value.status == .published }
    }

    private static func listAllDraftActivities() -> [String: Activity]? {
        self.allActivities.filter { $0.value.status == .draft }
    }

    private static func listAllTemplateActivities() -> [String: Activity]? {
        self.allActivities.filter { $0.value.status == .template }
    }

    private static func listAllPublishedCurriculums() -> [String: Curriculum]? {
        self.allCurriculums.filter { $0.value.status == .published }
    }

    private static func listAllDraftCurriculums() -> [String: Curriculum]? {
        self.allCurriculums.filter { $0.value.status == .draft }
    }

    private static func listAllTemplateCurriculums() -> [String: Curriculum]? {
        self.allCurriculums.filter { $0.value.status == .template }
    }

    private static func listAllStories() -> [String: Story]? {
        let bundle = Bundle.module
        let files = bundle.paths(forResourcesOfType: "story.yml", inDirectory: nil)

        var stories: [String: Story] = [:]

        for file in files {
            let data = try? String(contentsOfFile: file, encoding: .utf8)

            guard let data else {
                logCK.error("Error reading file: \(file)")
                continue
            }

            do {
                let story = try YAMLDecoder().decode(Story.self, from: data)
                stories[story.id] = story
            } catch {
                logCK.error("Error decoding file: \(file) with error:\n\(error)")
            }
        }

        return stories
    }

    private static func listAllResources() -> [String: CategoryResources]? {
        let bundle = Bundle.module
        var resources: [String: CategoryResources] = [:]
        let paths = bundle.paths(forResourcesOfType: "resources.yml", inDirectory: nil)

        for path in paths {
            let data = try? String(contentsOfFile: path, encoding: .utf8)

            guard let data else {
                logCK.error("Error reading file: \(path)")
                continue
            }

            do {
                let resource = try YAMLDecoder().decode(CategoryResources.self, from: data)
                resources[resource.id] = resource
            } catch {
                logCK.error("Error decoding file: \(path) with error:\n\(error)")
            }
        }

        return resources
    }
}
