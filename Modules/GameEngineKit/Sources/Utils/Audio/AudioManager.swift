// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import Foundation
import SwiftUI

// MARK: - AudioManager

public class AudioManager: NSObject {
    // MARK: Lifecycle

    override private init() {
        super.init()
        self.audioPlayer = AVAudioPlayer()
        self.audioPlayer?.delegate = self
    }

    // MARK: Public

    public enum AudioType {
        case file
        case speech
    }

    public enum State: Equatable {
        case playing(type: AudioType)
        case paused
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

    public func play(file: String) {
        if !(self.audioPlayer?.isPlaying ?? false), self.state.value == .paused {
            log.debug("Resuming audio playback")
            self.audioPlayer?.play()
            self.state.send(.playing(type: .file))
            return
        }

        log.debug("Playing audio: \(file)")
        self.setAudioPlayerData(file: file)
        guard let player = self.audioPlayer else { return }
        player.play()
        self.state.send(.playing(type: .file))
    }

    public func speak(text _: String) {
        self.state.send(.playing(type: .speech))
    }

    public func pause() {
        guard let player = self.audioPlayer else { return }

        if player.isPlaying {
            log.debug("Pausing audio playback")
            self.audioPlayer?.pause()
            self.state.send(.paused)
        }
    }

    public func stop() {
        log.debug("Stopping audio playback")

        self.state.send(.stopped)
        self.progress.send(.zero)
        self.cancellables.removeAll()

        self.audioPlayer?.stop()
    }

    // MARK: Private

    private var audioPlayer: AVAudioPlayer?

    private var cancellables: Set<AnyCancellable> = []

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
            .sink(receiveValue: { _ in
                guard let player = self.audioPlayer else { return }

                self.progress.send(Progress(currentTime: player.currentTime,
                                            duration: player.duration,
                                            percentage: CGFloat(player.currentTime / player.duration)))
            })
            .store(in: &self.cancellables)
    }
}

// MARK: AVAudioPlayerDelegate

extension AudioManager: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        log.debug("Audio playback finished")

        guard let player = self.audioPlayer else { return }

        self.stop()

        self.progress.send(Progress(currentTime: player.duration,
                                    duration: player.duration,
                                    percentage: 1.0))
    }
}

// MARK: - AudioManagerViewModel

class AudioManagerViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        self.audioManager.progress
            .receive(on: DispatchQueue.main)
            .sink {
                log.debug("Progress received: \(self.progress)")
                self.progress = $0
            }
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
            VStack {
                HStack {
                    Button("Play drums") {
                        audioManager.play(file: "drums")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)

                    Button("Speak now") {
                        audioManager.speak(text: "Hello, world!")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)

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
                .padding(.bottom)

                Text("State: \(viewModel.state)")
                Text("Progress: \(viewModel.progress)")
            }
        }
    }
    return PreviewWrapper()
}
