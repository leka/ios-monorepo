// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit

public enum MidiRecordingPlayer {
    // MARK: Public

    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.instrument = try container.decode(String.self, forKey: .instrument)
            self.songs = try container.decode([Song].self, forKey: .songs)
        }

        // MARK: Public

        public let instrument: String
        public let songs: [Song]

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case instrument
            case songs
        }
    }

    public struct Song: Codable, Hashable, Equatable {
        // MARK: Lifecycle

        public init(song: String) {
            self.audio = song
            self.song = MelodySong(rawValue: song)!
            self.labels = Labels(name: song, icon: "under_the_moonlight")
            self.localizedLabels = nil
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.audio = try container.decode(String.self, forKey: .audio)
            self.song = MelodySong(rawValue: self.audio)!
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

        public let song: MelodySong
        public let audio: String
        public let labels: Labels

        public static func == (lhs: MidiRecordingPlayer.Song, rhs: MidiRecordingPlayer.Song) -> Bool {
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

    public enum MelodySong: String, Codable {
        case none = ""
        case underTheMoonlight = "Under_The_Moonlight"
        case aGreenMouse = "A_Green_Mouse"
        case twinkleTwinkleLittleStar = "Twinkle_Twinkle_Little_Star"
        case ohTheCrocodiles = "Oh_The_Crocodiles"
        case happyBirthday = "Happy_Birthday"

        // MARK: Public

        public var scale: [UInt8] {
            switch self {
                case .none:
                    []
                case .underTheMoonlight:
                    [24, 26, 28, 29, 31, 33, 35, 36]
                case .aGreenMouse:
                    [24, 26, 28, 29, 31, 33, 34, 36]
                case .twinkleTwinkleLittleStar:
                    [24, 26, 28, 29, 31, 33, 35, 36]
                case .ohTheCrocodiles:
                    [24, 28, 29, 31, 33, 34, 35, 36]
                case .happyBirthday:
                    [24, 26, 28, 29, 31, 33, 34, 36]
            }
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
