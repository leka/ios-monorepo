// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension MelodyView {
    struct LauncherView: View {
        @Binding var selectedSong: MidiRecordingPlayer.Song
        @Binding var mode: Stage
        @Binding var keyboard: KeyboardType

        let songs: [MidiRecordingPlayer.Song]

        var body: some View {
            VStack(spacing: 50) {
                HStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ContentKitAsset.Exercises.Melody.imageIllustration.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)

                        KeyboardModeView(keyboard: self.$keyboard)
                    }

                    SongSelectorView(songs: self.songs, selectedMidiRecording: self.$selectedSong)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)

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
    MelodyView.LauncherView(
        selectedSong: .constant(MidiRecordingPlayer.Song(song: "Under_The_Moonlight")),
        mode: .constant(.waitingForSelection),
        keyboard: .constant(.partial),
        songs: [
            MidiRecordingPlayer.Song(song: "Under_The_Moonlight"),
            MidiRecordingPlayer.Song(song: "A_Green_Mouse"),
            MidiRecordingPlayer.Song(song: "Twinkle_Twinkle_Little_Star"),
        ]
    )
}
