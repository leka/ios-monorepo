// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import RobotKit
import SwiftUI

extension MusicalInstrumentView {
    struct XylophoneView: View {
        // MARK: Lifecycle

        init(midiPlayer: MIDIPlayer, scale: MIDIScale) {
            self.xyloPlayer = midiPlayer
            self.scale = scale
            self.tileNumber = scale.notes.count
            self.tilesSpacing = scale.self == .majorPentatonic ? 40 : 20
        }

        // MARK: Internal

        @ObservedObject var xyloPlayer: MIDIPlayer

        let tilesSpacing: CGFloat
        let tileNumber: Int
        let tileColors: [Robot.Color] = [.pink, .red, .orange, .yellow, .green, .lightBlue, .blue, .purple]
        let scale: MIDIScale

        var body: some View {
            HStack(spacing: self.tilesSpacing) {
                ForEach(0..<self.tileNumber) { index in
                    Button {
                        self.xyloPlayer.noteOn(number: self.scale.notes[index])
                        Robot.shared.shine(.all(in: self.tileColors[index]))
                    } label: {
                        self.tileColors[index].screen
                    }
                    .buttonStyle(
                        XylophoneTileButtonStyle(
                            index: index, tileNumber: self.tileNumber, tileWidth: self.scale.self == .majorPentatonic ? 130 : 100
                        )
                    )
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
