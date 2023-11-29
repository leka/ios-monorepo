// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import RobotKit
import SwiftUI

extension MusicalInstrumentView {

    struct XylophoneView: View {
        @ObservedObject var xyloPlayer: MIDIPlayer
        let tilesSpacing: CGFloat
        let tileNumber: Int
        let tileColors: [Robot.Color] = [.pink, .red, .orange, .yellow, .green, .blue, .purple]
        let scale: MIDIScale

        init(midiPlayer: MIDIPlayer, scale: MIDIScale) {
            self.xyloPlayer = midiPlayer
            self.scale = scale
            self.tileNumber = scale.notes.count
            self.tilesSpacing = scale.self == .majorPentatonic ? 40 : 16
        }

        var body: some View {
            HStack(spacing: tilesSpacing) {
                ForEach(0..<tileNumber) { index in
                    Button {
                        xyloPlayer.noteOn(number: scale.notes[index])
                        Robot.shared.shine(.all(in: tileColors[index]))
                    } label: {
                        tileColors[index].screen
                    }
                    .buttonStyle(TileButtonStyle(index: index, tileNumber: tileNumber))
                    .compositingGroup()
                }
            }
        }
    }

}

#Preview {
    MusicalInstrumentView.XylophoneView(
        midiPlayer: MIDIPlayer(instrument: .xylophone),
        scale: .majorPentatonic
    )
}
