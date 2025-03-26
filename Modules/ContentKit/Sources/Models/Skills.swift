// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import LogKit
import Version
import Yams

// MARK: - Skills

public class Skills {
    // MARK: Lifecycle

    private init() {
        self.container = Self.loadSkills()
    }

    // MARK: Public

    public static var allSkillsList: [Skill] {
        shared.getAllSkills()
    }

    public static var primarySkillsList: [Skill] {
        shared.getMainSkills()
    }

    public static func skill(id: String) -> Skill? {
        self.allSkillsList.first(where: { $0.id == id })
    }

    public static func getAllSubskills(for skill: Skill) -> [Skill] {
        var allSubskills: [Skill] = [skill]

        func getSubskills(for skill: Skill) -> [Skill] {
            var allSubskills: [Skill] = []

            for subskill in skill.subskills {
                allSubskills.append(subskill)
                allSubskills.append(contentsOf: getSubskills(for: subskill))
            }

            return allSubskills
        }

        allSubskills.append(contentsOf: getSubskills(for: skill))

        return allSubskills
    }

    // MARK: Private

    private struct SkillsContainer: Codable {
        let list: [Skill]
    }

    private static let shared: Skills = .init()

    private let container: SkillsContainer

    private static func loadSkills() -> SkillsContainer {
        if let fileURL = Bundle.module.url(forResource: "skills", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                let container = try YAMLDecoder().decode(SkillsContainer.self, from: yamlString)
                return container
            } catch {
                logCK.error("Failed to read YAML file: \(error)")
                return SkillsContainer(list: [])
            }
        } else {
            logCK.error("skills.yml not found")
            return SkillsContainer(list: [])
        }
    }

    private func getMainSkills() -> [Skill] {
        var skills: [Skill] = []

        for skill in self.container.list {
            skills.append(skill)
        }

        return skills
    }

    private func getAllSkills() -> [Skill] {
        var allSkills: [Skill] = []

        func getSubskills(for skill: Skill) -> [Skill] {
            var allSubskills: [Skill] = []

            for subskill in skill.subskills {
                allSubskills.append(subskill)
                allSubskills.append(contentsOf: getSubskills(for: subskill))
            }

            return allSubskills
        }

        for skill in self.container.list {
            allSkills.append(skill)
            allSkills.append(contentsOf: getSubskills(for: skill))
        }

        return allSkills
    }
}

// MARK: - Skill

public struct Skill: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        self.l10n = try container.decode([Skill.Localization].self, forKey: .l10n)

        let availableLocales = self.l10n.map(\.locale)

        let currentLocale = availableLocales.first(where: {
            $0.language.languageCode == LocalizationKit.l10n.language
        }) ?? Locale(identifier: "en_US")

        self.name = self.l10n.first(where: { $0.locale == currentLocale })!.name
        self.description = self.l10n.first(where: { $0.locale == currentLocale })!.description
        self.subskills = try container.decode([Skill].self, forKey: .subskills)
    }

    // MARK: Public

    public let id: String
    public let name: String
    public let description: String
    public let subskills: [Skill]

    // MARK: Private

    private let l10n: [Localization]
}

// MARK: Skill.Localization

public extension Skill {
    struct Localization: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.name = try container.decode(String.self, forKey: .name)
            self.description = try container.decode(String.self, forKey: .description)
        }

        // MARK: Internal

        let locale: Locale
        let name: String
        let description: String
    }
}

// MARK: Hashable

extension Skill: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: Equatable

extension Skill: Equatable {
    public static func == (lhs: Skill, rhs: Skill) -> Bool {
        lhs.id == rhs.id
    }
}
