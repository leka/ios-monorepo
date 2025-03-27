// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension DanceFreezeView {
    struct LauncherView: View {
        @Binding var mode: Stage
        @Binding var motion: Motion
        @Binding var selectedAudioRecording: DanceFreeze.Song

        let songs: [DanceFreeze.Song]

        var body: some View {
            VStack(spacing: 50) {
                Text(l10n.DanceFreezeView.instructions)
                    .font(.headline)
                    .padding(.top, 30)

                HStack(spacing: 30) {
                    VStack(spacing: 0) {
                        ContentKitAsset.Exercises.DanceFreeze.imageIllustration.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(80)
                        MotionSelectorView(motion: self.$motion)
                    }

                    SongSelectorView(
                        songs: self.songs,
                        selectedAudioRecording: self.$selectedAudioRecording
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)

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
    DanceFreezeView.LauncherView(
        mode: .constant(.waitingForSelection),
        motion: .constant(.rotation),
        selectedAudioRecording: .constant(DanceFreeze.Song(song: "Empty_Page")),
        songs: [
            DanceFreeze.Song(song: "Giggly_Squirrel"),
            DanceFreeze.Song(song: "Empty_Page"),
            DanceFreeze.Song(song: "Early_Bird"),
            DanceFreeze.Song(song: "Hands_On"),
            DanceFreeze.Song(song: "In_The_Game"),
            DanceFreeze.Song(song: "Little_by_little"),
        ]
    )
}
