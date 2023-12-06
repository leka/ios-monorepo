// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import DesignKit
import SwiftUI

// MARK: - SpeakerViewModel

// TODO(@ladislas): refactor speech synth into own class
class SpeakerViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    // MARK: Lifecycle

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    deinit {
        synthesizer.delegate = nil
    }

    // MARK: Internal

    @Published var isSpeaking = false

    func speak(sentence: String) {
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.rate = 0.40
        // TODO(@ladislas): handle different locales
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        synthesizer.speak(utterance)
    }

    // MARK: AVSpeechSynthesizerDelegate

    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.isSpeaking = true
    }

    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.isSpeaking = false
    }

    // MARK: Private

    private var synthesizer = AVSpeechSynthesizer()
}

// MARK: - ExerciseInstructionsButton

struct ExerciseInstructionsButton: View {
    @StateObject var speaker = SpeakerViewModel()
    @State var instructions: String

    var body: some View {
        Button(instructions) {
            speaker.speak(sentence: instructions)
        }
        .buttonStyle(StepInstructions_ButtonStyle(isSpeaking: $speaker.isSpeaking))
    }
}

// MARK: - StepInstructions_ButtonStyle

struct StepInstructions_ButtonStyle: ButtonStyle {
    // MARK: Internal

    @Binding var isSpeaking: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(spacing: 0) {
            Spacer()
            configuration.label
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
                .font(.system(size: 22, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 85)
            Spacer()
        }
        .frame(maxWidth: 640)
        .frame(height: 85, alignment: .center)
        .background(backgroundGradient)
        .overlay(buttonStroke)
        .overlay(speachIndicator)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10,
                style: .circular
            )
        )
        .shadow(
            color: .black.opacity(0.1),
            radius: isSpeaking ? 0 : 4, x: 0, y: isSpeaking ? 1 : 4
        )
        .scaleEffect(isSpeaking ? 0.98 : 1)
        .disabled(isSpeaking)
        .animation(.easeOut(duration: 0.2), value: isSpeaking)
    }

    // MARK: Private

    private var backgroundGradient: some View {
        ZStack {
            Color.white
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.0), .black.opacity(0.0)]),
                startPoint: .top, endPoint: .center
            )
            .opacity(isSpeaking ? 1 : 0)
        }
    }

    private var buttonStroke: some View {
        RoundedRectangle(
            cornerRadius: 10,
            style: .circular
        )
        .fill(
            .clear,
            strokeBorder: LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.2), .black.opacity(0.05)]),
                startPoint: .bottom,
                endPoint: .top
            ),
            lineWidth: 4
        )
        .opacity(isSpeaking ? 0.5 : 0)
    }

    private var speachIndicator: some View {
        HStack {
            Spacer()
            DesignKitAsset.Images.personTalking.swiftUIImage
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(
                    isSpeaking
                        ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : DesignKitAsset.Colors.darkGray.swiftUIColor
                )
                .padding(10)
        }
    }
}
