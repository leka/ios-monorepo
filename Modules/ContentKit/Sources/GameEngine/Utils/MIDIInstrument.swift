// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit

// MARK: - MIDIInstrument

enum MIDIInstrument: String {
    case xylophone

    // MARK: Internal

    var samples: [MIDISample] {
        switch self {
            case .xylophone:
                xyloSamples
        }
    }
}

private let xyloSamples: [MIDISample] =
    [
        MIDISample(file: "Xylo-24-C1.wav", note: 24),
        MIDISample(file: "Xylo-25-C#1.wav", note: 25),
        MIDISample(file: "Xylo-26-D1.wav", note: 26),
        MIDISample(file: "Xylo-27-D#1.wav", note: 27),
        MIDISample(file: "Xylo-28-E1.wav", note: 28),
        MIDISample(file: "Xylo-29-F1.wav", note: 29),
        MIDISample(file: "Xylo-30-F#1.wav", note: 30),
        MIDISample(file: "Xylo-31-G1.wav", note: 31),
        MIDISample(file: "Xylo-32-G#1.wav", note: 32),
        MIDISample(file: "Xylo-33-A1.wav", note: 33),
        MIDISample(file: "Xylo-34-A#1.wav", note: 34),
        MIDISample(file: "Xylo-35-B1.wav", note: 35),
        MIDISample(file: "Xylo-36-C2.wav", note: 36),
        MIDISample(file: "Xylo-37-C#2.wav", note: 37),
        MIDISample(file: "Xylo-38-D2.wav", note: 38),
        MIDISample(file: "Xylo-39-D#2.wav", note: 39),
        MIDISample(file: "Xylo-40-E2.wav", note: 40),
        MIDISample(file: "Xylo-41-F2.wav", note: 41),
        MIDISample(file: "Xylo-42-F#2.wav", note: 42),
        MIDISample(file: "Xylo-43-G2.wav", note: 43),
        MIDISample(file: "Xylo-44-G#2.wav", note: 44),
        MIDISample(file: "Xylo-45-A2.wav", note: 45),
        MIDISample(file: "Xylo-46-A#2.wav", note: 46),
        MIDISample(file: "Xylo-47-B2.wav", note: 47),
    ]
