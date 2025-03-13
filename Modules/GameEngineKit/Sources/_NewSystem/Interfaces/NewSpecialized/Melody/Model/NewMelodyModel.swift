// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - NewMelodyModel

public struct NewMelodyModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let instrumentDecoded = try container.decode(String.self, forKey: .instrument)
        self.songs = try container.decode([MidiRecordingPlayerSong].self, forKey: .songs)

        guard let instrument = MIDIInstrument(rawValue: instrumentDecoded) else {
            fatalError("Instrument \(instrumentDecoded) found")
        }

        self.instrument = instrument
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(NewMelodyModel.self, from: data)
        else {
            log.error("Exercise payload not compatible with Melody model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case instrument
        case songs
    }

    let instrument: MIDIInstrument
    let songs: [MidiRecordingPlayerSong]
}

// MARK: - MidiRecordingPlayerSong

struct MidiRecordingPlayerSong: Codable, Hashable, Equatable {
    // MARK: Lifecycle

    init(song: String) {
        self.audio = song
        self.song = MelodySong(rawValue: song)!
        self.labels = MelodyLabels(name: song, icon: "under_the_moonlight")
        self.localizedLabels = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.audio = try container.decode(String.self, forKey: .audio)
        self.song = MelodySong(rawValue: self.audio)!
        self.localizedLabels = try container.decode([MelodyLocalizedLabels].self, forKey: .localizedLabels)
        if let localizedLabels = self.localizedLabels {
            let availableLocales = localizedLabels.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.labels = self.localizedLabels?.first(where: { $0.locale == currentLocale })?.value ?? MelodyLabels(name: "", icon: "")
        } else {
            self.labels = MelodyLabels(name: "", icon: "")
        }
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case audio
        case localizedLabels = "labels"
    }

    let song: MelodySong
    let audio: String
    let labels: MelodyLabels

    static func == (lhs: MidiRecordingPlayerSong, rhs: MidiRecordingPlayerSong) -> Bool {
        lhs.audio == rhs.audio
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.audio)
    }

    // MARK: Private

    private let localizedLabels: [MelodyLocalizedLabels]?
}

// MARK: - MelodyLabels

struct MelodyLabels: Codable {
    // MARK: Lifecycle

    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decode(String.self, forKey: .icon)
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case name
        case icon
    }

    let name: String
    let icon: String
}

// MARK: - MelodySong

enum MelodySong: String, Codable {
    case none = ""
    case underTheMoonlight = "Under_The_Moonlight"
    case aGreenMouse = "A_Green_Mouse"
    case twinkleTwinkleLittleStar = "Twinkle_Twinkle_Little_Star"
    case ohTheCrocodiles = "Oh_The_Crocodiles"
    case happyBirthday = "Happy_Birthday"

    // MARK: Internal

    var scale: [UInt8] {
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

// MARK: - MelodyLocalizedLabels

struct MelodyLocalizedLabels: Codable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
        self.value = try container.decode(MelodyLabels.self, forKey: .value)
    }

    // MARK: Internal

    let locale: Locale
    let value: MelodyLabels

    // MARK: Private

    private enum CodingKeys: CodingKey {
        case locale
        case value
    }
}
