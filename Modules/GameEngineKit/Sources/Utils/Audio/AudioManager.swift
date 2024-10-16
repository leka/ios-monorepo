// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import LocalizationKit
import SwiftUI

// MARK: - AudioManager

public class AudioManager: NSObject {
    // MARK: Lifecycle

    override private init() {
        super.init()
        self.speechSynthesizer.delegate = self
    }

    // MARK: Public

    public enum AudioType: Equatable, CustomStringConvertible {
        case file(name: String)
        case speech(text: String)

        // MARK: Public

        public var description: String {
            switch self {
                case let .file(name):
                    "File (\(name))"
                case let .speech(text):
                    "Speech (\"\(text)\")"
            }
        }

        public var value: String {
            switch self {
                case let .file(name):
                    name
                case let .speech(text):
                    text
            }
        }
    }

    public enum State: Equatable {
        case playing(type: AudioType)
        case paused(whilePlaying: AudioType)
        case stopped
    }

    public struct Progress: Equatable {
        static let zero = Progress(currentTime: 0.0, duration: 0.0, percentage: 0.0)

        let currentTime: TimeInterval
        let duration: TimeInterval
        let percentage: CGFloat
    }

    public static var shared: AudioManager = .init()

    public private(set) var progress = CurrentValueSubject<Progress, Never>(.zero)
    public private(set) var state = CurrentValueSubject<AudioManager.State, Never>(.stopped)

    public func play(_ audioType: AudioType) {
        if case let .playing(currentType) = self.state.value {
            log.debug("Audio is already playing: \(currentType)")
            return
        }

        self.progress.send(.zero)

        switch audioType {
            case let .file(name):
                self.play(file: name)
            case let .speech(text):
                self.speak(text: text)
        }
    }

    public func pause() {
        guard case let .playing(audioType) = self.state.value else { return }

        switch audioType {
            case .file:
                self.pauseAudioPlayer()
            case .speech:
                self.pauseSpeechSynthetizer()
        }

        self.state.send(.paused(whilePlaying: audioType))
    }

    public func stop() {
        log.debug("Stopping audio playback")

        self.stopAudioPlayer()
        self.stopSpeechSynthesizer()

        self.state.send(.stopped)
        self.progress.send(.zero)
    }

    // MARK: Private

    private var audioPlayer: AVAudioPlayer?

    private var speechSynthesizer = AVSpeechSynthesizer()
    private var speechVoice: AVSpeechSynthesisVoice?
    private var speechSentence: String = ""

    private var cancellables: Set<AnyCancellable> = []

    private func pauseAudioPlayer() {
        guard let player = self.audioPlayer else { return }

        if player.isPlaying {
            log.debug("Pausing audio playback")
            self.audioPlayer?.pause()
        }
    }

    private func pauseSpeechSynthetizer() {
        self.speechSynthesizer.pauseSpeaking(at: .immediate)
    }

    private func stopAudioPlayer() {
        self.cancellables.removeAll()

        self.audioPlayer?.stop()
    }

    private func stopSpeechSynthesizer() {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
    }

    private func play(file: String) {
        let type = AudioType.file(name: file)

        if case let .paused(currentType) = self.state.value, currentType != type {
            return
        }

        if case let .paused(currentType) = self.state.value, currentType == type {
            guard let player = self.audioPlayer else { return }
            log.debug("Resuming audio playback")
            player.play()
            self.state.send(.playing(type: type))
            return
        }

        self.stopAudioPlayer()

        log.debug("Playing audio: \(file)")
        self.setAudioPlayerData(file: file)
        guard let player = self.audioPlayer else { return }
        player.play()
        self.state.send(.playing(type: type))
    }

    private func speak(text: String) {
        let type = AudioType.speech(text: text)

        if case let .paused(currentType) = self.state.value, currentType != type {
            return
        }

        if case let .paused(currentType) = self.state.value, currentType == type {
            log.debug("Resuming speech playback")
            if self.speechSynthesizer.isPaused {
                self.speechSynthesizer.continueSpeaking()
            }
            self.state.send(.playing(type: type))
            return
        }

        self.stopSpeechSynthesizer()

        self.setSpeechSynthetizerData(text: text)

        log.debug("Speaking text: \(text)")
        var utterance: AVSpeechUtterance {
            let utterance = AVSpeechUtterance(string: self.speechSentence)
            utterance.rate = 0.40
            utterance.voice = self.speechVoice
            return utterance
        }
        self.speechSynthesizer.speak(utterance)
        self.state.send(.playing(type: type))
    }

    private func setAudioPlayerData(file: String) {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            log.critical("Could not set Audio Session. Error: \(error)")
            return
        }

        do {
            if let url = Bundle.url(forAudio: file) {
                log.debug("Audio found at url: \(url)")
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            } else {
                log.error("Audio not found: \(file)")
                let fileURL = Bundle.module.url(forResource: file, withExtension: "mp3")!
                self.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            }

        } catch {
            log.error("mp3 file not found - \(error)")
            return
        }

        self.audioPlayer?.delegate = self
        self.audioPlayer?.prepareToPlay()

        Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                guard let player = self.audioPlayer else { return }

                self.progress.send(Progress(currentTime: player.currentTime,
                                            duration: player.duration,
                                            percentage: CGFloat(player.currentTime / player.duration)))
            }
            .store(in: &self.cancellables)
    }

    private func setSpeechSynthetizerData(text: String) {
        switch l10n.language {
            case .french:
                self.speechVoice = AVSpeechSynthesisVoice(language: "fr-FR")
            case .english:
                self.speechVoice = AVSpeechSynthesisVoice(language: "en-US")
            default:
                self.speechVoice = AVSpeechSynthesisVoice(language: "en-US")
        }

        if l10n.language == .french {
            self.speechSentence = text.replacingOccurrences(of: "Leka", with: "Léka")
            self.speechSentence = self.speechSentence.replacingOccurrences(of: "sent-il", with: "sentil")
            self.speechSentence = self.speechSentence.replacingOccurrences(of: "sent-elle", with: "sentelle")
        } else {
            self.speechSentence = text
        }
    }
}

// MARK: AVAudioPlayerDelegate

extension AudioManager: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        guard let player = self.audioPlayer else { return }

        self.stopAudioPlayer()
        self.state.send(.stopped)
        self.progress.send(Progress(currentTime: player.duration,
                                    duration: player.duration,
                                    percentage: 1.0))
    }
}

// MARK: AVSpeechSynthesizerDelegate

extension AudioManager: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
        self.stopSpeechSynthesizer()
        self.state.send(.stopped)
    }
}

// MARK: - AudioManagerViewModel

class AudioManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        self.audioManager.progress
            .receive(on: DispatchQueue.main)
            .sink { self.progress = $0 }
            .store(in: &self.cancellables)

        self.audioManager.state
            .receive(on: DispatchQueue.main)
            .sink { self.state = $0 }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var progress: AudioManager.Progress = .zero
    @Published var state: AudioManager.State = .stopped

    // MARK: Private

    private var audioManager: AudioManager = .shared
    private var cancellables: Set<AnyCancellable> = []
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject var viewModel = AudioManagerViewModel()

        var audioManager: AudioManager = .shared

        var body: some View {
            VStack(spacing: 40) {
                HStack {
                    Button("Play drums") {
                        audioManager.play(.file(name: "drums"))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)

                    Button("Play piano") {
                        audioManager.play(.file(name: "piano"))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)

                    Button("Say \"Hello, Worlds!\"") {
                        audioManager.play(.speech(text: "Hello, world!"))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)

                    Button("Say \"My name is Leka, I'm a robot\"") {
                        audioManager.play(.speech(text: "My name is Leka, I'm a robot"))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)
                }

                HStack {
                    Button("Pause") {
                        audioManager.pause()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)

                    Button("Stop") {
                        audioManager.stop()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }

                HStack {
                    Circle()
                        .frame(width: 100, height: 100)
                        .overlay(Text("🥁️"))
                        .foregroundColor(.green)
                        .opacity(viewModel.state == .playing(type: .file(name: "drums")) ? 1.0 : 0.2)

                    Circle()
                        .frame(width: 100, height: 100)
                        .overlay(Text("🎹"))
                        .foregroundColor(.mint)
                        .opacity(viewModel.state == .playing(type: .file(name: "piano")) ? 1.0 : 0.2)

                    Circle()
                        .frame(width: 100, height: 100)
                        .overlay(Text("👋️"))
                        .foregroundColor(.teal)
                        .opacity(viewModel.state == .playing(type: .speech(text: "Hello, world!")) ? 1.0 : 0.2)

                    Circle()
                        .frame(width: 100, height: 100)
                        .overlay(Text("🤖️"))
                        .foregroundColor(.cyan)
                        .opacity(viewModel.state == .playing(type: .speech(text: "My name is Leka, I'm a robot")) ? 1.0 : 0.2)
                }

                VStack {
                    Text("State: \(viewModel.state)")
                    Text("Progress: \(viewModel.progress)")
                }
            }
        }
    }

    return PreviewWrapper()
}
