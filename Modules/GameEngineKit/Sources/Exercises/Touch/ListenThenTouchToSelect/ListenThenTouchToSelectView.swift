// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ListenThenTouchToSelectView: View {
    // MARK: Lifecycle

    public init(choices: [TouchToSelect.Choice], audioRecording: String, shuffle: Bool = false) {
        _viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices, shuffle: shuffle))
        _audioPlayer = StateObject(wrappedValue: AudioPlayerViewModel(player: AudioPlayer(audioRecording: audioRecording)))
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? TouchToSelect.Payload else {
            log.error("Payload not recognized: \(String(describing: exercise.payload))")
            fatalError("💥 Payload not recognized: \(String(describing: exercise.payload))")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(choices: payload.choices, shuffle: payload.shuffleChoices, shared: data))

        switch exercise.action {
            case let .ipad(type: .audio(name)):
                log.debug("Audio name: \(name)")
                _audioPlayer = StateObject(wrappedValue: AudioPlayerViewModel(player: AudioPlayer(audioRecording: name)))
            case let .ipad(type: .speech(utterance)):
                log.debug("Speech utterance: \(utterance)")
                _audioPlayer = StateObject(wrappedValue: AudioPlayerViewModel(player: SpeechSynthesizer(sentence: utterance)))
            default:
                log.error("Action not recognized: \(String(describing: exercise.action))")
                fatalError("💥 Action not recognized: \(String(describing: exercise.action))")
        }
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
                    OneChoiceView(viewModel: self.viewModel, isTappable: self.audioPlayer.state == .finishedPlaying)
                        .onTapGestureIf(self.audioPlayer.state == .finishedPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.state == .finishedPlaying)
                        .grayscale(self.audioPlayer.state == .finishedPlaying ? 0.0 : 1.0)

                case .twoChoices:
                    TwoChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.state == .finishedPlaying)
                        .onTapGestureIf(self.audioPlayer.state == .finishedPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.state == .finishedPlaying)
                        .grayscale(self.audioPlayer.state == .finishedPlaying ? 0.0 : 1.0)

                case .threeChoices:
                    ThreeChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.state == .finishedPlaying)
                        .onTapGestureIf(self.audioPlayer.state == .finishedPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.state == .finishedPlaying)
                        .grayscale(self.audioPlayer.state == .finishedPlaying ? 0.0 : 1.0)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.state == .finishedPlaying)
                        .onTapGestureIf(self.audioPlayer.state == .finishedPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.state == .finishedPlaying)
                        .grayscale(self.audioPlayer.state == .finishedPlaying ? 0.0 : 1.0)

                case .fiveChoices:
                    FiveChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.state == .finishedPlaying)
                        .onTapGestureIf(self.audioPlayer.state == .finishedPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.state == .finishedPlaying)
                        .grayscale(self.audioPlayer.state == .finishedPlaying ? 0.0 : 1.0)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel, isTappable: self.audioPlayer.state == .finishedPlaying)
                        .onTapGestureIf(self.audioPlayer.state == .finishedPlaying) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.audioPlayer.state == .finishedPlaying)
                        .grayscale(self.audioPlayer.state == .finishedPlaying ? 0.0 : 1.0)

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
    @StateObject private var audioPlayer: AudioPlayerViewModel
}
