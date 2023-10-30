// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import Combine
import SwiftUI

public class MelodyGameplay: ObservableObject {
    @Published public var progress: CGFloat = 0.0
    @Published public var state: GameplayStateDeprecated = .idle

    private let xyloPlayer = MIDIPlayer(name: "Xylophone", samples: xyloSamples)

    private let song: MelodySongModel

    private var midiNotes: [MIDINoteData] = []
    private var currentNoteNumber: MIDINoteNumber = 0
    private var currentNoteIndex: Int = 0

    public init(song: MelodySongModel) {
        self.song = song
        self.state = .playing
        self.xyloPlayer.loadMIDIFile(fileUrl: song.midiFile, tempo: song.tempo)
        self.midiNotes = xyloPlayer.getMidiNotes()
        self.currentNoteNumber = midiNotes[currentNoteIndex].noteNumber - song.octaveGap

        // TODO(@ladislas): Light on Leka lights with the following color getter
        print(getColorFromMIDINote())
    }

    func process(tile: XylophoneTile) {
        guard currentNoteIndex < midiNotes.count else { return }

        if tile.noteNumber == currentNoteNumber {
            xyloPlayer.noteOn(
                number: currentNoteNumber, velocity: midiNotes[currentNoteIndex].velocity)
            currentNoteIndex += 1
            if currentNoteIndex < midiNotes.count {
                currentNoteNumber = midiNotes[currentNoteIndex].noteNumber - song.octaveGap
                print(getColorFromMIDINote())
            }
            progress = CGFloat(currentNoteIndex) / CGFloat(midiNotes.count)
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
                    self.currentNoteIndex = 0
                    self.progress = 0
                }
            }

        }
    }

    func getColorFromMIDINote() -> Color {
        let index = kListOfTiles.firstIndex(where: {
            $0.noteNumber == currentNoteNumber
        })
        return kListOfTiles[index!].color
    }
}
