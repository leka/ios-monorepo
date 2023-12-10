// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import ContentKit
import Foundation

// MARK: - AudioPlayer

public class AudioPlayer: NSObject, ObservableObject {
    // MARK: Lifecycle

    public init(audioRecording: AudioRecording) {
        super.init()
        self.setAudioPlayer(audioRecording: audioRecording)
        self.didFinishPlaying = false
    }

    // MARK: Internal

    @Published var progress: CGFloat = 0.0
    @Published var didFinishPlaying = false

    var isPlaying: Bool {
        self.player.isPlaying
    }

    func setAudioPlayer(audioRecording: AudioRecording) {
        self.progress = 0.0
        self.didFinishPlaying = false

        do {
            let fileURL = Bundle.module.url(forResource: audioRecording.file, withExtension: "mp3")!
            self.player = try AVAudioPlayer(contentsOf: fileURL)
            self.player.delegate = self
        } catch {
            print("ERROR - mp3 file not found - \(error)")
            return
        }

        self.player.prepareToPlay()

        Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if let player = self.player {
                    let newProgress = CGFloat(player.currentTime / player.duration)
                    if self.progress > newProgress {
                        self.progress = 1.0
                    } else {
                        self.progress = newProgress
                    }
                }
            })
            .store(in: &self.cancellables)
    }

    func play() {
        self.player.play()
        self.didFinishPlaying = false
    }

    func pause() {
        self.player.pause()
    }

    func stop() {
        self.player.stop()
        self.didFinishPlaying = true
    }

    // MARK: Private

    private var player: AVAudioPlayer!

    private var cancellables: Set<AnyCancellable> = []
}

// MARK: AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        self.didFinishPlaying = true
    }
}
