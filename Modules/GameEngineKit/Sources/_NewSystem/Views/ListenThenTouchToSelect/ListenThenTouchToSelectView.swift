// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ListenThenTouchToSelectView: View {

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    @StateObject private var viewModel: SelectionViewViewModel
    @StateObject private var audioPlayer: AudioPlayer

    public init(choices: [TouchSelection.Choice], audioRecording: AudioRecordingModel) {
        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: choices))
        self._audioPlayer = StateObject(wrappedValue: AudioPlayer(audioRecording: audioRecording))
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard
            case .selection(let payload) = exercise.payload,
            case .ipad(type: .audio(let name)) = exercise.action
        else {
            log.error("Exercise payload is not .selection and/or Exercise does not contain iPad audio action")
            fatalError("💥 Exercise payload is not .selection and/or Exercise does not contain iPad audio action")
        }

        self._viewModel = StateObject(
            wrappedValue: SelectionViewViewModel(choices: payload.choices, shared: data))

        let audioRecording = AudioRecordingModel(name: name, file: name)
        self._audioPlayer = StateObject(wrappedValue: AudioPlayer(audioRecording: audioRecording))
    }

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            ActionButtonListen(audioPlayer: audioPlayer)
                .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: viewModel, isTappable: audioPlayer.didFinishPlaying)
                        .onTapGestureIf(audioPlayer.didFinishPlaying) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: audioPlayer.didFinishPlaying)

                case .twoChoices:
                    TwoChoicesView(viewModel: viewModel, isTappable: audioPlayer.didFinishPlaying)
                        .onTapGestureIf(audioPlayer.didFinishPlaying) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: audioPlayer.didFinishPlaying)

                case .threeChoices:
                    ThreeChoicesView(viewModel: viewModel, isTappable: audioPlayer.didFinishPlaying)
                        .onTapGestureIf(audioPlayer.didFinishPlaying) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: audioPlayer.didFinishPlaying)

                case .fourChoices:
                    FourChoicesView(viewModel: viewModel, isTappable: audioPlayer.didFinishPlaying)
                        .onTapGestureIf(audioPlayer.didFinishPlaying) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: audioPlayer.didFinishPlaying)

                case .fiveChoices:
                    FiveChoicesView(viewModel: viewModel, isTappable: audioPlayer.didFinishPlaying)
                        .onTapGestureIf(audioPlayer.didFinishPlaying) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: audioPlayer.didFinishPlaying)

                case .sixChoices:
                    SixChoicesView(viewModel: viewModel, isTappable: audioPlayer.didFinishPlaying)
                        .onTapGestureIf(audioPlayer.didFinishPlaying) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: audioPlayer.didFinishPlaying)

                default:
                    Text("❌ Interface not available for \(viewModel.choices.count) choices")
            }

            Spacer()
        }
    }

}
