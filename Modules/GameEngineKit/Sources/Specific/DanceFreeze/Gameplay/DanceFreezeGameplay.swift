// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import SwiftUI

public class DanceFreezeGameplay {
    var audioPlayer: AVAudioPlayer!
    @Published public var progress: CGFloat = 0.0
    @Published public var state: GameplayState = .idle

    var cancellables: Set<AnyCancellable> = []

    public init() {
        // Nothing to do
    }

    func process() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    func setAudioPlayer(song: SongModel) {
        do {
            let path = Bundle.main.path(forResource: song.file, ofType: "mp3")!
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            print(audioPlayer.description)
        } catch {
            print("ERROR - mp3 file not found - \(error)")
            return
        }

        audioPlayer.prepareToPlay()

        Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                if let player = self.audioPlayer {
                    self.progress = CGFloat(player.currentTime / player.duration)
                }
            })
            .store(in: &cancellables)
    }
}
