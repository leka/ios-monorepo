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

    override init() {
        super.init()
        self.synthesizer.delegate = self
        self.state.send(.idle)
    }

    convenience init(sentence: String) {
        self.init()
        self.setAudioData(data: sentence)
    }

    deinit {
        synthesizer.delegate = nil
    }

    // MARK: Internal

    var progress = CurrentValueSubject<CGFloat, Never>(0.0)
    var state = CurrentValueSubject<AudioPlayerState, Never>(.idle)

    func setAudioData(data: String) {
        self.state.send(.idle)

        let voice = switch l10n.language {
            case .french:
                AVSpeechSynthesisVoice(language: "fr-FR")
            case .english:
                AVSpeechSynthesisVoice(language: "en-US")
            default:
                AVSpeechSynthesisVoice(language: "en-US")
        }

        var finalSentence: String {
            if l10n.language == .french {
                data.replacingOccurrences(of: "Leka", with: "Léka")
            } else {
                data
            }
        }

        self.utterance = AVSpeechUtterance(string: finalSentence)
        self.utterance.rate = 0.40
        self.utterance.voice = voice
    }

    func play() {
        if self.synthesizer.isPaused {
            self.synthesizer.continueSpeaking()
            return
        }

        if !self.synthesizer.isSpeaking {
            self.synthesizer.speak(self.utterance)
        }
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

    private var utterance = AVSpeechUtterance()

    private var synthesizer = AVSpeechSynthesizer()
}
