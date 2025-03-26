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
        self.audioData = .file(name: audioRecording)
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? TouchToSelect.Payload else {
            logGEK.error("Payload not recognized: \(String(describing: exercise.payload))")
            fatalError("💥 Payload not recognized: \(String(describing: exercise.payload))")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(choices: payload.choices, shuffle: payload.shuffleChoices, shared: data))

        switch exercise.action {
            case let .ipad(type: .audio(name)):
                self.audioData = .file(name: name)
            case let .ipad(type: .speech(utterance)):
                self.audioData = .speech(text: utterance)
            default:
                logGEK.error("Action not recognized: \(String(describing: exercise.action))")
                fatalError("💥 Action not recognized: \(String(describing: exercise.action))")
        }
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            ActionButtonListen(audio: self.audioData)
                .padding(20)
                .simultaneousGesture(TapGesture().onEnded {
                    self.audioHasBeenPlayed = true
                })

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            self.currentInterface
                .animation(.easeOut(duration: 0.3), value: self.audioHasBeenPlayed)
                .disabled(!self.audioHasBeenPlayed)
                .grayscale(self.audioHasBeenPlayed ? 0 : 1)

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
    @State private var audioHasBeenPlayed: Bool = false

    private let audioData: AudioManager.AudioType

    @ViewBuilder
    private var currentInterface: some View {
        let interface = Interface(rawValue: viewModel.choices.count)
        switch interface {
            case .oneChoice:
                OneChoiceView(viewModel: self.viewModel, isTappable: true)

            case .twoChoices:
                TwoChoicesView(viewModel: self.viewModel, isTappable: true)

            case .threeChoices:
                ThreeChoicesView(viewModel: self.viewModel, isTappable: true)

            case .fourChoices:
                FourChoicesView(viewModel: self.viewModel, isTappable: true)

            case .fiveChoices:
                FiveChoicesView(viewModel: self.viewModel, isTappable: true)

            case .sixChoices:
                SixChoicesView(viewModel: self.viewModel, isTappable: true)

            default:
                EmptyView()
        }
    }
}

#Preview {
    let choices: [TouchToSelect.Choice] = [
        TouchToSelect.Choice(value: "red", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "blue", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "green", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "yellow", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "purple", type: .color, isRightAnswer: false),
        TouchToSelect.Choice(value: "lightBlue", type: .color, isRightAnswer: true),
    ]

    return ListenThenTouchToSelectView(
        choices: choices, audioRecording: "drums"
    )
}
