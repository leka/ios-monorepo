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

    private var player: AVAudioPlayer?

    private var timerCancellable: AnyCancellable?

    public init(audioRecording: AudioRecording) {
        super.init()
        setRecording(audioRecording)
        didFinishPlaying = false
    }

    func setRecording(_ recording: AudioRecording) {
        progress = 0.0
        didFinishPlaying = false

        guard
            let fileURL = Bundle.main.url(forResource: recording.file, withExtension: "mp3")
                ?? Bundle.module.url(forResource: recording.file, withExtension: "mp3")
        else {
            log.error("File \(recording.file) not found")
            return
        }

        do {
            log.trace("AudioRecoding file \"\(recording.file)\" found at \(fileURL.relativePath)")
            self.player = try AVAudioPlayer(contentsOf: fileURL)
            player?.delegate = self
        } catch {
            log.error("AVAudioPlayer error: \(error)")
        }

        player?.prepareToPlay()
    }

    private func startProgressTimer() {
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .default)
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
    }

    private func reset() {
        player?.currentTime = 0
        progress = 0.0
        timerCancellable?.cancel()
    }

    func play() {
        startProgressTimer()
        player?.play()
        didFinishPlaying = false
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.stop()
        reset()
        didFinishPlaying = true
    }

    var isPlaying: Bool {
        player?.isPlaying ?? false
    }

}

extension AudioPlayer: AVAudioPlayerDelegate {

    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        didFinishPlaying = true
        reset()
    }

}
