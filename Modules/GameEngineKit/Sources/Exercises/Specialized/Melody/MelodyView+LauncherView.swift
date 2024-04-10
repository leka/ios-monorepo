// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

extension MelodyView {
    struct LauncherView: View {
        @Binding var selectedSong: MidiRecording
        @Binding var mode: Stage
        @Binding var keyboard: KeyboardType
        let songs: [MidiRecording]

        var body: some View {
            VStack(spacing: 100) {
                HStack(spacing: 30) {
                    GameEngineKitAsset.Exercises.Melody.imageIllustration.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(80)

                    VStack(spacing: 0) {
                        KeyboardModeView(keyboard: self.$keyboard)

                        SongSelectorView(songs: self.songs, selectedMidiRecording: self.$selectedSong)
                    }
                }

                Button {
                    self.mode = .selectionConfirmed
                } label: {
                    ButtonLabel(String(l10n.MelodyView.playButtonLabel.characters), color: .cyan)
                }
            }
        }
    }
}

#Preview {
    let songs = [
        MidiRecording(.underTheMoonlight),
        MidiRecording(.aGreenMouse),
        MidiRecording(.twinkleTwinkleLittleStar),
        MidiRecording(.londonBridgeIsFallingDown),
        MidiRecording(.ohTheCrocodiles),
        MidiRecording(.happyBirthday),
    ]

    return MelodyView.LauncherView(
        selectedSong: .constant(MidiRecording(.underTheMoonlight)),
        mode: .constant(.waitingForSelection),
        keyboard: .constant(.partial),
        songs: songs
    )
}
