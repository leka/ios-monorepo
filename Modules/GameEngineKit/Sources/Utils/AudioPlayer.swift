// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import ContentKit
import Foundation

// MARK: - AudioPlayer

public class AudioPlayer: NSObject, AudioPlayerProtocol {
    // MARK: Lifecycle

    override private init() {
        self.state.send(.idle)
    }

    // MARK: Public

    public static var shared: AudioPlayer = .init()

    // MARK: Internal

    var progress = CurrentValueSubject<CGFloat, Never>(0.0)
    var state = CurrentValueSubject<AudioPlayerState, Never>(.idle)

    func setAudioData(data: String) {
        self.stop()

        self.progress.send(0.0)
        self.state.send(.idle)

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            log.critical("Could not set Audio Session. Error: \(error).")
            fatalError("Could not set Audio Session. Error: \(error).")
        }

        do {
            if let url = Bundle.url(forAudio: data) {
                log.debug("Audio found at url: \(url)")
                self.player = try AVAudioPlayer(contentsOf: url)
            } else {
                log.error("Audio not found: \(data)")
                let fileURL = Bundle.module.url(forResource: data, withExtension: "mp3")!
                self.player = try AVAudioPlayer(contentsOf: fileURL)
            }

            self.player?.delegate = self
        } catch {
            log.error("mp3 file not found - \(error)")
            return
        }

        self.player?.prepareToPlay()

        Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if let player = self.player {
                    let newProgress = CGFloat(player.currentTime / player.duration)
                    if self.progress.value > newProgress {
                        self.progress.send(1.0)
                    } else {
                        self.progress.send(newProgress)
                    }
                }
            })
            .store(in: &self.cancellables)
    }

    func play() {
        self.player?.play()
        self.state.send(.playing)
    }

    func pause() {
        self.player?.pause()
        self.state.send(.idle)
    }

    func stop() {
        self.player?.stop()
        self.state.send(.idle)
        self.cancellables.removeAll()
    }

    // MARK: Private

    private var player: AVAudioPlayer?

    private var cancellables: Set<AnyCancellable> = []
}

// MARK: AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        self.state.send(.finishedPlaying)
    }
}
