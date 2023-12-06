// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension DanceFreeze {

    struct PlayerView: View {
        @ObservedObject var viewModel: MainViewViewModel

        let isAuto: Bool
        let motion: Motion

        public init(viewModel: MainViewViewModel, isAuto: Bool, motion: Motion) {
            self.viewModel = viewModel
            self.isAuto = isAuto
            self.motion = motion
        }

        var body: some View {
            VStack {
                ContinuousProgressBar(progress: viewModel.progress)
                    .padding(20)

                Button {
                    viewModel.onDanceFreezeToggle()
                } label: {
                    if viewModel.isDancing {
                        DanceView()
                    } else {
                        FreezeView()
                    }
                }
                .disabled(isAuto)
                .onAppear {
                    viewModel.setMotionMode(motion: motion)
                    viewModel.onDanceFreezeToggle()
                    if isAuto {
                        randomSwitch()
                    }
                }
                .onDisappear {
                    viewModel.exercicesSharedData.state = .completed
                }
            }
        }

        func randomSwitch() {
            if viewModel.progress < 1.0, viewModel.exercicesSharedData.state != .completed {
                let rand = Double.random(in: 2..<10)

                DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                    viewModel.onDanceFreezeToggle()
                    randomSwitch()
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
