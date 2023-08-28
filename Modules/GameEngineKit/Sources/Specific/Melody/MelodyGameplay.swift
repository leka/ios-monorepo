// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import Combine
import SwiftUI

public class MelodyGameplay {
    private let song: MelodySongModel
    private var sequenceTrack: [MIDINoteData] = []

    @Published private var currentNote: UInt8 = 0
    @Published private var step = 0
    @Published public var progress: CGFloat = 0.0
    @Published public var state: GameplayState = .idle
    @Published var xyloPlayer = MIDIPlayer(name: "Xylophone", samples: xyloSamples)

    public init(song: MelodySongModel) {
        self.song = song
        self.state = .playing
        self.xyloPlayer.loadMIDIFile(fileUrl: song.midiFile, tempo: song.tempo)
        self.sequenceTrack = xyloPlayer.getSequenceTrack()
        self.currentNote = sequenceTrack[step].noteNumber - song.octaveGap

        // TODO(@ladislas): Light on Leka lights with the following color getter
        print(getColorFromMIDINote())
    }

    func process(tile: XylophoneTile) {
        guard step < sequenceTrack.count else { return }

        if tile.note == currentNote {
            xyloPlayer.noteOn(
                number: currentNote, velocity: sequenceTrack[step].velocity)
            step += 1
            if step < sequenceTrack.count {
                currentNote = sequenceTrack[step].noteNumber - song.octaveGap
                print(getColorFromMIDINote())
            }
            progress = CGFloat(step) / CGFloat(sequenceTrack.count)
        }

        if progress == 1.0 {
            self.xyloPlayer.setInstrumentCallback(callback: { _, note, velocity in
                self.xyloPlayer.noteOn(number: note - self.song.octaveGap, velocity: velocity)
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                print("Replay song")
                self.xyloPlayer.play()

                // TODO(@hugo): BUG - length is not correct, it returns 32 seconds but the track is ~12 secondes long
                DispatchQueue.main.asyncAfter(deadline: .now() + self.xyloPlayer.getDuration()) {
                    print("Reset UI")
                    self.state = .finished
                    self.step = 0
                    self.progress = 0
                }
            }

        }
    }

    func getColorFromMIDINote() -> Color {
        let index = kListOfTiles.firstIndex(where: {
            $0.note == currentNote
        })
        return kListOfTiles[index!].color
    }
}
