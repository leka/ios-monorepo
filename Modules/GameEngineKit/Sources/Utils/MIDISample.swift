// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import AudioKit
import SwiftUI

struct MIDISample {
    var name: String
    var fileName: String
    var midiNote: Int
    var audioFile: AVAudioFile?

    init(_ prettyName: String, file: String, note: Int) {
        name = prettyName
        fileName = file
        midiNote = note

        guard let fileURL = Bundle.module.resourceURL?.appendingPathComponent(file) else { return }
        do {
            audioFile = try AVAudioFile(forReading: fileURL)
        } catch {
            Log("Could not load: \(fileName)")
        }
    }
}

let xyloSamples: [MIDISample] =
    [
        MIDISample("C1", file: "24Xylo - C1.wav", note: 24),
        MIDISample("C#1", file: "25Xylo - C#1.wav", note: 25),
        MIDISample("D1", file: "26Xylo - D1.wav", note: 26),
        MIDISample("D#1", file: "27Xylo - D#1.wav", note: 27),
        MIDISample("E1", file: "28Xylo - E1.wav", note: 28),
        MIDISample("F1", file: "29Xylo - F1.wav", note: 29),
        MIDISample("F#1", file: "30Xylo - F#1.wav", note: 30),
        MIDISample("G1", file: "31Xylo - G1.wav", note: 31),
        MIDISample("G#1", file: "32Xylo - G#1.wav", note: 32),
        MIDISample("A1", file: "33Xylo - A1.wav", note: 33),
        MIDISample("A#1", file: "34Xylo - A#1.wav", note: 34),
        MIDISample("B1", file: "35Xylo - B1.wav", note: 35),
        MIDISample("C2", file: "36Xylo - C2.wav", note: 36),
        MIDISample("C#2", file: "37Xylo - C#2.wav", note: 37),
        MIDISample("D2", file: "38Xylo - D2.wav", note: 38),
        MIDISample("D#2", file: "39Xylo - D#2.wav", note: 39),
        MIDISample("E2", file: "40Xylo - E2.wav", note: 40),
        MIDISample("F2", file: "41Xylo - F2.wav", note: 41),
        MIDISample("F#2", file: "42Xylo - F#2.wav", note: 42),
        MIDISample("G2", file: "43Xylo - G2.wav", note: 43),
        MIDISample("G#2", file: "44Xylo - G#2.wav", note: 44),
        MIDISample("A2", file: "45Xylo - A2.wav", note: 45),
        MIDISample("A#2", file: "46Xylo - A#2.wav", note: 46),
        MIDISample("B2", file: "47Xylo - B2.wav", note: 47),
    ]
