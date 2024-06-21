// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import Combine
import LocalizationKit
import SwiftUI

// MARK: - SpeechSynthesizer

// TODO(@ladislas): refactor speech synth into own class
class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate, AudioPlayerProtocol {
    // MARK: Lifecycle

    override private init() {
        super.init()
        self.synthesizer.delegate = self
        self.state.send(.idle)
    }

    deinit {
        synthesizer.delegate = nil
    }

    // MARK: Public

    public static var shared: SpeechSynthesizer = .init()

    // MARK: Internal

    var progress = CurrentValueSubject<CGFloat, Never>(0.0)
    var state = CurrentValueSubject<AudioPlayerState, Never>(.idle)

    func setAudioData(data: String) {
        self.stop()

        self.state.send(.idle)

        switch l10n.language {
            case .french:
                self.voice = AVSpeechSynthesisVoice(language: "fr-FR")
            case .english:
                self.voice = AVSpeechSynthesisVoice(language: "en-US")
            default:
                self.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        if l10n.language == .french {
            self.finalSentence = data.replacingOccurrences(of: "Leka", with: "Léka")
            self.finalSentence = self.finalSentence.replacingOccurrences(of: "sent-il", with: "sentil")
            self.finalSentence = self.finalSentence.replacingOccurrences(of: "sent-elle", with: "sentelle")
        } else {
            self.finalSentence = data
        }
    }

    func play() {
        if self.synthesizer.isPaused {
            self.synthesizer.continueSpeaking()
            return
        }

        let utterance = AVSpeechUtterance(string: self.finalSentence)
        utterance.rate = 0.40
        utterance.voice = self.voice
        self.synthesizer.speak(utterance)
    }

    func pause() {
        self.synthesizer.pauseSpeaking(at: .immediate)
    }

    func stop() {
        self.synthesizer.stopSpeaking(at: .immediate)
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didStart _: AVSpeechUtterance) {
        self.state.send(.playing)
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
        self.state.send(.finishedPlaying)
    }

    // MARK: Private

    private var synthesizer = AVSpeechSynthesizer()

    private var voice = AVSpeechSynthesisVoice(language: "en-US")

    private var finalSentence: String = ""
}
