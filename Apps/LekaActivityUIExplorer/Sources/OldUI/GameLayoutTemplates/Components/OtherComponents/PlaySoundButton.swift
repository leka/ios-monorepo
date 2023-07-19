// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct PlaySoundButton: View {

    @EnvironmentObject var gameEngine: GameEngine

    var body: some View {
        Button(
            action: {
                gameEngine.audioPlayer.play()
            },
            label: {
                Image(systemName: "speaker.2")
                    .font(.system(size: 100, weight: .medium))
                    .foregroundColor(.accentColor)
                    .padding(40)
            }
        )
        .frame(width: 200)
        .disabled(gameEngine.audioPlayer.isPlaying)
        .buttonStyle(PlaySound_ButtonStyle(progress: gameEngine.progress))
        .scaleEffect(gameEngine.audioPlayer.isPlaying ? 1.0 : 0.8, anchor: .center)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: gameEngine.audioPlayer.isPlaying ? 6 : 3, x: 0, y: 3
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.45), value: gameEngine.audioPlayer.isPlaying)
    }
}
