// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import SwiftUI

// MARK: - MusicalInstrumentView

struct MusicalInstrumentView: View {
    // MARK: Lifecycle

    init(instrument: MIDIInstrument, scale: MIDIScale) {
        self.instrument = instrument
        self.scale = scale
        _midiPlayer = StateObject(wrappedValue: MIDIPlayer(instrument: instrument))
    }

    init(model: MusicalInstrumentModel) {
        self.instrument = model.instrument
        self.scale = model.scale
        _midiPlayer = StateObject(wrappedValue: MIDIPlayer(instrument: model.instrument))
    }

    // MARK: Internal

    @StateObject var midiPlayer: MIDIPlayer

    let instrument: MIDIInstrument
    let scale: MIDIScale

    var body: some View {
        switch self.instrument {
            case .xylophone:
                XylophoneView(midiPlayer: self.midiPlayer, scale: self.scale)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    MusicalInstrumentView(instrument: .xylophone, scale: .majorPentatonic)
}
