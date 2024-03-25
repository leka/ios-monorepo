// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension DanceFreezeView {
    struct LauncherView: View {
        @Binding var mode: Stage
        @Binding var motion: Motion
        @Binding var selectedAudioRecording: AudioRecording
        let songs: [AudioRecording]

        var body: some View {
            VStack(spacing: 100) {
                Text(l10n.DanceFreezeView.instructions)
                    .font(.headline)
                    .padding(.top, 30)

                HStack(spacing: 30) {
                    VStack(spacing: 0) {
                        ContentKitAsset.GameEngineExercises.DanceFreeze.imageIllustration.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    VStack(spacing: 0) {
                        MotionSelectorView(motion: self.$motion)

                        SongSelectorView(
                            songs: self.songs,
                            selectedAudioRecording: self.$selectedAudioRecording
                        )
                    }
                }
                .padding(.horizontal, 100)

                HStack(spacing: 70) {
                    Button {
                        self.mode = .manualMode
                    } label: {
                        StageModeButtonStyle(String(l10n.DanceFreezeView.manualButtonLabel.characters), color: .cyan)
                    }

                    Button {
                        self.mode = .automaticMode
                    } label: {
                        StageModeButtonStyle(String(l10n.DanceFreezeView.autoButtonLabel.characters), color: .mint)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    let songs = [
        AudioRecording(name: "Giggly Squirrel", file: "Giggly_Squirrel"),
        AudioRecording(name: "Empty Page", file: "Empty_Page"),
        AudioRecording(name: "Early Bird", file: "Early_Bird"),
        AudioRecording(name: "Hands On", file: "Hands_On"),
        AudioRecording(name: "In The Game", file: "In_The_Game"),
        AudioRecording(name: "Little by Little", file: "Little_by_little"),
    ]

    return DanceFreezeView.LauncherView(
        mode: .constant(.waitingForSelection),
        motion: .constant(.rotation),
        selectedAudioRecording: .constant(AudioRecording(.gigglySquirrel)),
        songs: songs
    )
}
