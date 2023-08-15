// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ListenTwoChoicesView: View {
    @ObservedObject private var viewModel: GenericViewModel
    @ObservedObject private var audioPlayer: AudioPlayer
    let horizontalSpacing: CGFloat = 32
    let verticalSpacing: CGFloat = 32
    let answerSize: CGFloat = 300

    public init(gameplay: any GameplayProtocol, audioRecording: AudioRecordingModel) {
        self.viewModel = GenericViewModel(gameplay: gameplay)
        self.audioPlayer = AudioPlayer(audioRecording: audioRecording)
    }

    public var body: some View {
        HStack(spacing: 0) {
            PlayButton(audioPlayer: audioPlayer)
                .padding(20)
            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)
            Spacer()
            answersLayout
            Spacer()
        }
    }

    private var answersLayout: some View {
        HStack(spacing: horizontalSpacing) {
            ForEach(0..<2) { index in
                let choice = viewModel.choices[index]

                ChoiceView(
                    choice: choice, size: answerSize, isTappable: audioPlayer.didFinishPlaying
                )
                .onTapGestureIf(audioPlayer.didFinishPlaying) {
                    viewModel.onChoiceTapped(choice: choice)
                }
            }
        }
    }
}
