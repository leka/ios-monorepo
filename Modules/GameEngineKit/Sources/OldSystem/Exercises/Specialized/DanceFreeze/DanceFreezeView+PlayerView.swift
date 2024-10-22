// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension DanceFreezeView {
    struct PlayerView: View {
        // MARK: Lifecycle

        public init(selectedAudioRecording: DanceFreeze.Song, isAuto: Bool, motion: Motion, data: ExerciseSharedData? = nil) {
            self._viewModel = StateObject(wrappedValue: ViewModel(selectedAudioRecording: selectedAudioRecording, motion: motion, shared: data))
            self.isAuto = isAuto
            self.motion = motion
        }

        // MARK: Internal

        let isAuto: Bool
        let motion: Motion

        var body: some View {
            VStack {
                ContinuousProgressBar(progress: self.viewModel.progress)
                    .padding(20)

                Button {
                    self.viewModel.onDanceFreezeToggle()
                } label: {
                    if self.viewModel.isDancing {
                        DanceView()
                    } else {
                        FreezeView()
                    }
                }
                .disabled(self.isAuto)
            }
            .onAppear {
                self.viewModel.onDanceFreezeToggle()
                if self.isAuto {
                    self.randomSwitch()
                }
            }
            .onDisappear {
                self.viewModel.completeDanceFreeze()
            }
        }

        func randomSwitch() {
            if case .completed = self.viewModel.exercicesSharedData.state { return }
            if self.viewModel.progress < 1.0 {
                let rand = Double.random(in: 1..<(self.viewModel.isDancing ? 10 : 3))

                DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                    if case .completed = self.viewModel.exercicesSharedData.state { return }
                    self.viewModel.onDanceFreezeToggle()
                    self.randomSwitch()
                }
            }
        }

        // MARK: Private

        @StateObject private var viewModel: ViewModel
    }
}

#Preview {
    DanceFreezeView.PlayerView(selectedAudioRecording: DanceFreeze.Song(song: "Early_Bird"), isAuto: true, motion: .movement)
}
