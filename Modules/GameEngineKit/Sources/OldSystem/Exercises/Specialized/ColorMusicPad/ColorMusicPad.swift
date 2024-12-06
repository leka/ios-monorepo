// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import DesignKit
import RobotKit
import SwiftUI

struct ColorMusicPad: View {
    // MARK: Internal

    @StateObject var midiPlayer: MIDIPlayer = .init(instrument: MIDIInstrument.xylophone)

    var body: some View {
        LazyVGrid(columns: self.columns, spacing: self.kHorizontalSpacing) {
            ForEach(0..<10) { index in
                Rectangle()
                    .fill(self.colors[index].screen)
                    .onTapGesture {
                        Robot.shared.shine(.all(in: self.colors[index]))
                        self.midiPlayer.noteOn(number: self.scale.notes[index])
                    }
                    .frame(width: self.kTileWidth, height: self.kTileHeight)
            }
        }
    }

    // MARK: Private

    private let scale: MIDIScale = .majorPentatonicDoubleOctave
    private let colors: [Robot.Color] = [.lightPink, .red, .orange, .yellow, .green, .mint, .lightBlue, .blue, .purple, .pink]
    private let columns = Array(repeating: GridItem(), count: 5)
    private let kHorizontalSpacing: CGFloat = 0
    private let kTileWidth: CGFloat = 220
    private let kTileHeight: CGFloat = 600
}

#Preview {
    ColorMusicPad()
}
