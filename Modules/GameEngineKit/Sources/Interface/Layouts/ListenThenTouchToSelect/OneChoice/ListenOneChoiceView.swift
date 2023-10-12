// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ListenOneChoiceView: View {
    @StateObject private var viewModel: GenericViewModel
    @StateObject private var audioPlayer: AudioPlayer
    let horizontalSpacing: CGFloat = 32
    let answerSize: CGFloat = 300

    public init(gameplay: any SelectionGameplayProtocol, audioRecording: AudioRecordingModel) {
        self._viewModel = StateObject(wrappedValue: GenericViewModel(gameplay: gameplay))
        self._audioPlayer = StateObject(wrappedValue: AudioPlayer(audioRecording: audioRecording))
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
            ChoiceView(
                choice: viewModel.choices[0], size: answerSize, isTappable: audioPlayer.didFinishPlaying
            )
            .onTapGestureIf(audioPlayer.didFinishPlaying) {
                viewModel.onChoiceTapped(choice: viewModel.choices[0])
            }
            .animation(.easeOut(duration: 0.3), value: audioPlayer.didFinishPlaying)
            Spacer()
        }
    }
}
