// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - MusicalInstrumentModel

public struct MusicalInstrumentModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let instrumentDecoded = try container.decode(String.self, forKey: .instrument)
        let scaleDecoded = try container.decode(String.self, forKey: .scale)

        guard let instrument = MIDIInstrument(rawValue: instrumentDecoded),
              let scale = MIDIScale(rawValue: scaleDecoded)
        else {
            fatalError("Instrument \(instrumentDecoded) found")
        }

        self.instrument = instrument
        self.scale = scale
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(MusicalInstrumentModel.self, from: data) else {
            logGEK.error("Exercise payload not compatible with MusicalInstrument model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case instrument
        case scale
    }

    let instrument: MIDIInstrument
    let scale: MIDIScale
}
