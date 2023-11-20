// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct Play_ButtonStyle: ButtonStyle {
    var progress: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .mask(Circle().inset(by: 4))
            .background(
                Circle()
                    .fill(
                        Color.white, strokeBorder: DesignKitAsset.Colors.gameButtonBorder.swiftUIColor,
                        lineWidth: 4
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.2), value: progress)
                    )
            )
            .contentShape(Circle())
    }
}

struct PlayButton: View {
    @ObservedObject var audioPlayer: AudioPlayerDeprecated

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
        .buttonStyle(Play_ButtonStyle(progress: audioPlayer.progress))
        .scaleEffect(audioPlayer.isPlaying ? 1.0 : 0.8, anchor: .center)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: audioPlayer.isPlaying ? 6 : 3, x: 0, y: 3
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.45), value: audioPlayer.isPlaying)
    }
}
