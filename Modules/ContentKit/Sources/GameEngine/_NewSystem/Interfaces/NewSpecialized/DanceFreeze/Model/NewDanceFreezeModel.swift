// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - NewDanceFreezeModel

public struct NewDanceFreezeModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.songs = try container.decode([DanceFreezeSong].self, forKey: .songs)
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(NewDanceFreezeModel.self, from: data) else {
            logGEK.error("Exercise payload not compatible with DanceFreeze model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case songs
    }

    let songs: [DanceFreezeSong]
}

// MARK: - DanceFreezeSong

public struct DanceFreezeSong: Codable, Hashable, Equatable {
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

    public static func == (lhs: DanceFreezeSong, rhs: DanceFreezeSong) -> Bool {
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

    let audio: String
    let labels: Labels

    // MARK: Private

    private let localizedLabels: [LocalizedLabels]?
}

// MARK: - Labels

struct Labels: Codable {
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

// MARK: - LocalizedLabels

private struct LocalizedLabels: Codable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
        self.value = try container.decode(Labels.self, forKey: .value)
    }

    // MARK: Internal

    let locale: Locale
    let value: Labels

    // MARK: Private

    private enum CodingKeys: CodingKey {
        case locale
        case value
    }
}
