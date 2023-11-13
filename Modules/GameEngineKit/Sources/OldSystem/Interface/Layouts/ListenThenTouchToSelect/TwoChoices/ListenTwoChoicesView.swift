// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ListenTwoChoicesView: View {
    @StateObject private var viewModel: GenericViewModel
    @StateObject private var audioPlayer: AudioPlayerDeprecated
    let horizontalSpacing: CGFloat = 60
    let answerSize: CGFloat = 300

    public init(gameplay: any SelectionGameplayProtocol, audioRecording: AudioRecordingModelDeprecated) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
        self._audioPlayer = StateObject(wrappedValue: AudioPlayerDeprecated(audioRecording: audioRecording))
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

                ChoiceViewDeprecated(
                    choice: choice, size: answerSize, isTappable: audioPlayer.didFinishPlaying
                )
                .onTapGestureIfDeprecated(audioPlayer.didFinishPlaying) {
                    viewModel.onChoiceTapped(choice: choice)
                }
            }
        }
    }
}
