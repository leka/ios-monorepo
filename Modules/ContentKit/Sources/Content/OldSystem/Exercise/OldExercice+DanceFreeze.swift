// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

// MARK: - DanceFreeze

public enum DanceFreeze {
    // MARK: Public

    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.songs = try container.decode([Song].self, forKey: .songs)
        }

        // MARK: Public

        public let songs: [Song]

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case songs
        }
    }

    public struct Song: Codable, Hashable, Equatable {
        // MARK: Lifecycle

        public init(song: String) {
            self.audio = song
            self.labels = Labels(name: song, icon: "early_page")
            self.localizedLabels = nil
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.audio = try container.decode(String.self, forKey: .audio)
            self.localizedLabels = try container.decode([LocalizedLabels].self, forKey: .localizedLabels)
            if let localizedLabels = self.localizedLabels {
                let availableLocales = localizedLabels.map(\.locale)

                let currentLocale = availableLocales.first(where: {
                    $0.language.languageCode == LocalizationKit.l10n.language
                }) ?? Locale(identifier: "en_US")

                self.labels = self.localizedLabels?.first(where: { $0.locale == currentLocale })?.value ?? Labels(name: "", icon: "")
            } else {
                self.labels = Labels(name: "", icon: "")
            }
        }

        // MARK: Public

        public let audio: String
        public let labels: Labels

        public static func == (lhs: Song, rhs: Song) -> Bool {
            lhs.audio == rhs.audio
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.audio)
        }

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case audio
            case localizedLabels = "labels"
        }

        // MARK: Private

        private let localizedLabels: [LocalizedLabels]?
    }

    public struct Labels: Codable {
        // MARK: Lifecycle

        public init(name: String, icon: String) {
            self.name = name
            self.icon = icon
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.icon = try container.decode(String.self, forKey: .icon)
        }

        // MARK: Public

        public let name: String
        public let icon: String

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case name
            case icon
        }
    }

    // MARK: Internal

    struct LocalizedLabels: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
            self.value = try container.decode(Labels.self, forKey: .value)
        }

        // MARK: Public

        public let locale: Locale
        public let value: Labels

        // MARK: Private

        private enum CodingKeys: CodingKey {
            case locale
            case value
        }
    }
}
