// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import SwiftUI

struct MIDISample {
    var fileName: String
    var midiNote: Int
    var audioFile: AVAudioFile?

    init(file: String, note: Int) {
        fileName = file
        midiNote = note

        guard let fileURL = Bundle.module.resourceURL?.appendingPathComponent(file) else { return }
        do {
            audioFile = try AVAudioFile(forReading: fileURL)
        } catch {
            fatalError("Could not load: \(fileName)")
        }
    }
}
