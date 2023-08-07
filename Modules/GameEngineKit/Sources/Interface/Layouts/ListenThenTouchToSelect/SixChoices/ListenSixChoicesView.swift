// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension View {
    func onTapGestureIf(_ condition: Bool, closure: @escaping () -> Void) -> some View {
        self.allowsHitTesting(condition)
            .onTapGesture {
                closure()
            }
    }
}

struct DeactivableChoiceView: View {
    var choice: ChoiceViewModel
    let size: CGFloat
    @ObservedObject var audioPlayer: AudioPlayer
    @ObservedObject var viewModel: GenericViewModel

    var body: some View {
        ChoiceView(choice: choice, size: size)
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

public struct ListenSixChoicesView: View {
    @ObservedObject private var viewModel: GenericViewModel
    @ObservedObject private var audioPlayer: AudioPlayer
    let horizontalSpacing: CGFloat = 80
    let verticalSpacing: CGFloat = 32
    let answerSize: CGFloat = 200

    public init(gameplay: any GameplayProtocol, song: AudioRecordingModel) {
        self.viewModel = GenericViewModel(gameplay: gameplay)
        self.audioPlayer = AudioPlayer(song: song)
    }

    public var body: some View {
        HStack(spacing: 0) {
            PlaySoundButton(audioPlayer: audioPlayer)
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
                ForEach(0..<3) { index in
                    let choice = viewModel.choices[index]

                    DeactivableChoiceView(
                        choice: choice, size: answerSize, audioPlayer: audioPlayer, viewModel: viewModel)
                }
            }
            GridRow {
                ForEach(3..<6) { index in
                    let choice = viewModel.choices[index]

                    DeactivableChoiceView(
                        choice: choice, size: answerSize, audioPlayer: audioPlayer, viewModel: viewModel)
                }
            }
        }
    }
}
