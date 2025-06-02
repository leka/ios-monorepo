// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MelodyPlayerButton: View {
    let viewModel: NewMelodyViewViewModel

    var body: some View {
        VStack {
            Button {
                self.viewModel.playSong()
                withAnimation {
                    self.viewModel.isMelodyPlaying.toggle()
                }
            } label: {
                Image(systemName: self.viewModel.isMelodyPlaying ? "speaker.wave.2.circle" : "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .background {
                        Circle()
                            .fill(.white)
                    }
            }
            .disabled(self.viewModel.isMelodyPlaying)
            .frame(width: 300)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    let songs: [MidiRecordingPlayerSong] = [
        MidiRecordingPlayerSong(song: "Under_The_Moonlight"),
    ]
    let coordinator = NewMelodyCoordinator(instrument: .xylophone, songs: songs)
    let viewModel = NewMelodyViewViewModel(coordinator: coordinator)
    MelodyPlayerButton(viewModel: viewModel)
}
