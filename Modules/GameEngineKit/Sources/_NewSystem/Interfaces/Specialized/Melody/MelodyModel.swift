// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - MelodyModel

public struct MelodyModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let instrumentDecoded = try container.decode(String.self, forKey: .instrument)
        self.songs = try container.decode([MidiRecordingPlayer.Song].self, forKey: .songs)

        guard let instrument = MIDIInstrument(rawValue: instrumentDecoded) else {
            fatalError("Instrument \(instrumentDecoded) found")
        }

        self.instrument = instrument
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(MelodyModel.self, from: data)
        else {
            logGEK.error("Exercise payload not compatible with Melody model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
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
    let songs: [MidiRecordingPlayer.Song]
}
