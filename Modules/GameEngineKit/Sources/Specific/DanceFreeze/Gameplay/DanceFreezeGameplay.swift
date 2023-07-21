// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import SwiftUI

public class DanceFreezeGameplay: NSObject, AVAudioPlayerDelegate {
    @Published var audioPlayer: AVAudioPlayer!
    @Published private var audioPlaying = false
    @Published public var progress: CGFloat = 0.0
    @Published public var state: GameplayState = .idle

    func process() {
        if audioPlaying {
            audioPlayer.pause()
            audioPlaying.toggle()
        } else {
            audioPlayer.play()
            audioPlaying.toggle()
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
        audioPlayer.delegate = self

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = self.audioPlayer {
                self.progress = CGFloat(player.currentTime / player.duration)
            }
        }
    }
}
