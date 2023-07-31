// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DeactivableChoiceView: View {
    var choice: ChoiceViewModel
    @ObservedObject var audioPlayer: AudioPlayer
    @ObservedObject var viewModel: ListenSixChoicesGridViewModel

    var body: some View {
        ChoiceView(choice: choice)
            .onTapGestureIf(audioPlayer.audioHasBeenPlayed) {
                viewModel.onChoiceTapped(choice: choice)
            }
            .overlay(
                Circle()
                    .fill(audioPlayer.audioHasBeenPlayed ? .clear : .white.opacity(0.6))
            )
            .animation(.easeOut(duration: 0.3), value: audioPlayer.audioHasBeenPlayed)
    }
}
