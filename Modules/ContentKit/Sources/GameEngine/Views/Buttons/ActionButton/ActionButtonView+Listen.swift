// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension ActionButtonView {
    struct ListenButton: View {
        // MARK: Lifecycle

        init(audio: AudioManager.AudioType) {
            self.audio = audio
        }

        // MARK: Internal

        let audio: AudioManager.AudioType

        var body: some View {
            ZStack {
                ActionButtonPulse(isPulsing: self.isPulsing)
                    .onAppear {
                        self.isPulsing = true
                    }

                Button {
                    self.audioManager.play(self.audio)
                    self.isPulsing = false

                } label: {
                    Image(systemName: "speaker.2")
                        .font(.system(size: 100, weight: .medium))
                        .foregroundColor(self.styleManager.accentColor!)
                        .padding(40)
                }
                .frame(width: 200)
                .disabled(self.isPlaying)
                .buttonStyle(Style(progress: self.isPlaying ? self.audioManagerViewModel.progress.percentage : 0))
                .scaleEffect(self.isPlaying ? 1.0 : 0.8, anchor: .center)
                .shadow(
                    color: self.styleManager.accentColor!.opacity(0.2),
                    radius: self.isPlaying ? 6 : 3, x: 0, y: 3
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.45), value: self.isPlaying)
                .onDisappear {
                    self.audioManager.stop()
                }
            }
        }

        // MARK: Private

        @StateObject private var audioManagerViewModel = AudioManagerViewModel()
        @State private var isPulsing: Bool = false

        private let audioManager = AudioManager.shared
        private let styleManager = StyleManager.shared

        private var isPlaying: Bool {
            if case let .playing(audio) = self.audioManagerViewModel.state, audio == self.audio {
                true
            } else {
                false
            }
        }
    }
}

#Preview {
    HStack {
        ActionButtonView.ListenButton(audio: .file(name: "piano"))
        ActionButtonView.ListenButton(audio: .speech(text: "Hello, World!"))
        ActionButtonView.ListenButton(audio: .file(name: "drums"))
        ActionButtonView.ListenButton(audio: .speech(text: "My name is Leka"))
    }
}
