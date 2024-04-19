// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ListenThenTouchToSelectView: View {
    // MARK: Lifecycle

    public init(choices: [TouchToSelect.Choice], audioRecording: AudioRecording, shuffle: Bool = false) {
        _viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices, shuffle: shuffle))
        _audioPlayer = StateObject(wrappedValue: AudioPlayer(audioRecording: audioRecording))
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? TouchToSelect.Payload,
              case let .ipad(type: .audio(name)) = exercise.action
        else {
            log.error("Exercise payload is not .selection and/or Exercise does not contain iPad audio action")
            fatalError("💥 Exercise payload is not .selection and/or Exercise does not contain iPad audio action")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(choices: payload.choices, shuffle: payload.shuffleChoices, shared: data))

        let audioRecording = AudioRecording(name: name, file: name)
        _audioPlayer = StateObject(wrappedValue: AudioPlayer(audioRecording: audioRecording))
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            ActionButtonListen(audioPlayer: self.audioPlayer)
                .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: self.viewModel, isTappable: self.audioPlayer.didFinishPlaying)
                        .onTapGestureIf(self.audioPlayer.didFinishPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.didFinishPlaying)
                        .grayscale(self.audioPlayer.didFinishPlaying ? 0.0 : 1.0)

                case .twoChoices:
                    TwoChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.didFinishPlaying)
                        .onTapGestureIf(self.audioPlayer.didFinishPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.didFinishPlaying)
                        .grayscale(self.audioPlayer.didFinishPlaying ? 0.0 : 1.0)

                case .threeChoices:
                    ThreeChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.didFinishPlaying)
                        .onTapGestureIf(self.audioPlayer.didFinishPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.didFinishPlaying)
                        .grayscale(self.audioPlayer.didFinishPlaying ? 0.0 : 1.0)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.didFinishPlaying)
                        .onTapGestureIf(self.audioPlayer.didFinishPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.didFinishPlaying)
                        .grayscale(self.audioPlayer.didFinishPlaying ? 0.0 : 1.0)

                case .fiveChoices:
                    FiveChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.didFinishPlaying)
                        .onTapGestureIf(self.audioPlayer.didFinishPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.didFinishPlaying)
                        .grayscale(self.audioPlayer.didFinishPlaying ? 0.0 : 1.0)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.didFinishPlaying)
                        .onTapGestureIf(self.audioPlayer.didFinishPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.didFinishPlaying)
                        .grayscale(self.audioPlayer.didFinishPlaying ? 0.0 : 1.0)

                default:
                    ProgressView()
            }

            Spacer()
        }
    }

    // MARK: Internal

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    // MARK: Private

    @StateObject private var viewModel: TouchToSelectViewViewModel
    @StateObject private var audioPlayer: AudioPlayer
}
