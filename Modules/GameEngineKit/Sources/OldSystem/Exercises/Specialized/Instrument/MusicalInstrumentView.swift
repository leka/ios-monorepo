// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import SwiftUI

struct MusicalInstrumentView: View {
    // MARK: Lifecycle

    init(instrument: MIDIInstrument, scale: MIDIScale) {
        self.instrument = instrument
        self.scale = scale
        _midiPlayer = StateObject(wrappedValue: MIDIPlayer(instrument: instrument))
    }

    init(exercise: Exercise, data _: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? MusicalInstrument.Payload else {
            fatalError("Exercise payload is not .instrument")
        }

        guard let instrument = MIDIInstrument(rawValue: payload.instrument),
              let scale = MIDIScale(rawValue: payload.scale)
        else {
            fatalError("Instrument or scale not found")
        }

        self.instrument = instrument
        self.scale = scale
        _midiPlayer = StateObject(wrappedValue: MIDIPlayer(instrument: instrument))
    }

    // MARK: Internal

    @StateObject var midiPlayer: MIDIPlayer
    let instrument: MIDIInstrument
    let scale: MIDIScale

    var body: some View {
        switch self.instrument {
            case .xylophone:
                XylophoneView(midiPlayer: self.midiPlayer, scale: self.scale)
        }
    }
}

#Preview {
    MusicalInstrumentView(instrument: .xylophone, scale: .majorPentatonic)
}
