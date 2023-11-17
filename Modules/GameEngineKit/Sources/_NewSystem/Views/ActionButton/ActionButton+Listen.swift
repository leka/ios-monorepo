// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

struct ActionButtonListen: View {
    @ObservedObject var audioPlayer: AudioPlayer

    var body: some View {
        Button {
            audioPlayer.play()
        } label: {
            Image(systemName: "speaker.2")
                .font(.system(size: 100, weight: .medium))
                .foregroundColor(.accentColor)
                .padding(40)
        }
        .frame(width: 200)
        .disabled(audioPlayer.isPlaying)
        .buttonStyle(ActionButtonStyle(progress: audioPlayer.progress))
        .scaleEffect(audioPlayer.isPlaying ? 1.0 : 0.8, anchor: .center)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: audioPlayer.isPlaying ? 6 : 3, x: 0, y: 3
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.45), value: audioPlayer.isPlaying)
    }
}

#Preview {
    ActionButtonListen(
        audioPlayer: AudioPlayer(recording: AudioRecording(name: "drums", file: "drums")))
}
