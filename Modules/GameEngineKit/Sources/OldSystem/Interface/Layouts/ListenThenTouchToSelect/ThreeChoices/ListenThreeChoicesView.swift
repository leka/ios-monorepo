// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct ListenThreeChoicesView: View {
    @StateObject private var viewModel: GenericViewModel
    @StateObject private var audioPlayer: AudioPlayerDeprecated
    let horizontalSpacing: CGFloat = 32
    let verticalSpacing: CGFloat = 32
    let answerSize: CGFloat = 230

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
        Grid(
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        ) {
            GridRow {
                ChoiceViewDeprecated(
                    choice: viewModel.choices[0], size: answerSize, isTappable: audioPlayer.didFinishPlaying
                )
                .onTapGestureIfDeprecated(audioPlayer.didFinishPlaying) {
                    viewModel.onChoiceTapped(choice: viewModel.choices[0])
                }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ChoiceViewDeprecated(
                    choice: viewModel.choices[1], size: answerSize, isTappable: audioPlayer.didFinishPlaying
                )
                .onTapGestureIfDeprecated(audioPlayer.didFinishPlaying) {
                    viewModel.onChoiceTapped(choice: viewModel.choices[1])
                }
            }
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ChoiceViewDeprecated(
                    choice: viewModel.choices[2], size: answerSize, isTappable: audioPlayer.didFinishPlaying
                )
                .onTapGestureIfDeprecated(audioPlayer.didFinishPlaying) {
                    viewModel.onChoiceTapped(choice: viewModel.choices[2])
                }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
        }
    }
}
