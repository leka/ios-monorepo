// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import SwiftUI

struct MIDISample {
    // MARK: Lifecycle

    init(file: String, note: Int) {
        self.fileName = file
        self.midiNote = note

        guard let fileURL = Bundle.module.resourceURL?.appendingPathComponent(file) else { return }
        do {
            self.audioFile = try AVAudioFile(forReading: fileURL)
        } catch {
            fatalError("Could not load: \(self.fileName)")
        }
    }

    // MARK: Internal

    var fileName: String
    var midiNote: Int
    var audioFile: AVAudioFile?
}
