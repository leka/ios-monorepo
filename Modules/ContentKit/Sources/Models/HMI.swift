// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import LogKit
import Version
import Yams

// MARK: - HMI

public class HMI: Codable {
    // MARK: Lifecycle

    private init() {
        self.container = Self.loadHMI()
    }

    // MARK: Public

    public static var list: [HMIDetails] {
        shared.container.list
    }

    public static func hmi(id: String) -> HMIDetails? {
        self.list.first(where: { $0.id == id })
    }

    // MARK: Private

    private struct HMIContainer: Codable {
        let list: [HMIDetails]
    }

    private static let shared: HMI = .init()

    private let container: HMIContainer

    private static func loadHMI() -> HMIContainer {
        if let fileURL = Bundle.module.url(forResource: "hmi", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                let container = try YAMLDecoder().decode(HMIContainer.self, from: yamlString)
                return container
            } catch {
                logCK.error("Failed to read YAML file: \(error)")
                return HMIContainer(list: [])
            }
        } else {
            logCK.error("hmi.yml not found")
            return HMIContainer(list: [])
        }
    }
}

// MARK: - HMIDetails

public struct HMIDetails: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        self.l10n = try container.decode([HMIDetails.Localization].self, forKey: .l10n)

        let availableLocales = self.l10n.map(\.locale)

        let currentLocale = availableLocales.first(where: {
            $0.language.languageCode == LocalizationKit.l10n.language
        }) ?? Locale(identifier: "en_US")

        self.name = self.l10n.first(where: { $0.locale == currentLocale })!.name
        self.description = self.l10n.first(where: { $0.locale == currentLocale })!.description
    }

    // MARK: Public

    public let id: String
    public let name: String
    public let description: String

    // MARK: Private

    private let l10n: [Localization]
}

// MARK: HMIDetails.Localization

public extension HMIDetails {
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
