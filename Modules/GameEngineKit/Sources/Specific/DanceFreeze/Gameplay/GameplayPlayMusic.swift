// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import SwiftUI

public class GameplayPlayMusic: NSObject, AVAudioPlayerDelegate {
    public let name = "Play music"
    @Published var audioPlayer: AVAudioPlayer!
    @Published private var isPlaying = false
    @Published public var progress: CGFloat = 0.0
    @Published public var isFinished: Bool = false

    public var progressPublisher: Published<CGFloat>.Publisher { $progress }
    public var isFinishedPublisher: Published<Bool>.Publisher { $isFinished }

    func process() {
        if isPlaying {
            audioPlayer.pause()
            isPlaying.toggle()
        } else {
            audioPlayer.play()
            isPlaying.toggle()
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
