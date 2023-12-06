// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import ContentKit
import Foundation

public class AudioPlayer: NSObject, ObservableObject {
    @Published var progress: CGFloat = 0.0
    @Published var didFinishPlaying = false

    private var player: AVAudioPlayer!

    private var cancellables: Set<AnyCancellable> = []

    public init(audioRecording: AudioRecording) {
        super.init()
        setAudioPlayer(audioRecording: audioRecording)
        didFinishPlaying = false
    }

    func setAudioPlayer(audioRecording: AudioRecording) {
        progress = 0.0
        didFinishPlaying = false

        do {
            let fileURL = Bundle.module.url(forResource: audioRecording.file, withExtension: "mp3")!
            player = try AVAudioPlayer(contentsOf: fileURL)
            player.delegate = self
        } catch {
            print("ERROR - mp3 file not found - \(error)")
            return
        }

        player.prepareToPlay()

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
            .store(in: &cancellables)
    }

    func play() {
        player.play()
        didFinishPlaying = false
    }

    func pause() {
        player.pause()
    }

    func stop() {
        player.stop()
        didFinishPlaying = true
    }

    var isPlaying: Bool {
        self.player.isPlaying
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        didFinishPlaying = true
    }
}
