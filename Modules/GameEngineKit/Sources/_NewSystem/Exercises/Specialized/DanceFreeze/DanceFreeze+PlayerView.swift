// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension DanceFreeze {
    struct PlayerView: View {
        // MARK: Lifecycle

        public init(viewModel: MainViewViewModel, isAuto: Bool, motion: Motion) {
            self.viewModel = viewModel
            self.isAuto = isAuto
            self.motion = motion
        }

        // MARK: Internal

        @ObservedObject var viewModel: MainViewViewModel

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
                .onAppear {
                    self.viewModel.setMotionMode(motion: self.motion)
                    self.viewModel.onDanceFreezeToggle()
                    if self.isAuto {
                        self.randomSwitch()
                    }
                }
                .onDisappear {
                    self.viewModel.exercicesSharedData.state = .completed
                }
            }
        }

        func randomSwitch() {
            guard self.viewModel.exercicesSharedData.state != .completed else { return }
            if self.viewModel.progress < 1.0, self.viewModel.exercicesSharedData.state != .completed {
                let rand = Double.random(in: 2..<10)

                DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                    guard self.viewModel.exercicesSharedData.state != .completed else { return }
                    self.viewModel.onDanceFreezeToggle()
                    self.randomSwitch()
                }
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

    let viewModel = DanceFreeze.MainViewViewModel(songs: songs)

    return DanceFreeze.PlayerView(viewModel: viewModel, isAuto: true, motion: .movement)
}
