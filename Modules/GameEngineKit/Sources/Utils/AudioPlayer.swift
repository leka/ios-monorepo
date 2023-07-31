// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import Combine
import Foundation

public class AudioPlayer: ObservableObject {
    @Published var player: AVAudioPlayer!
	@Published var progress: CGFloat = 0.0
	@Published var audioHasBeenPlayed = false

    private var cancellables: Set<AnyCancellable> = []

    public init(song: SongModel = SongModel(name: "", file: "")) {
        setAudioPlayer(song: song)
		audioHasBeenPlayed = false
    }

    func setAudioPlayer(song: SongModel) {
        do {
            let path = Bundle.main.path(forResource: song.file, ofType: "mp3")!
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
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
                    self.progress = CGFloat(player.currentTime / player.duration)
                }
            })
            .store(in: &cancellables)
    }

    func play() {
        player.play()
		audioHasBeenPlayed = true
    }

    func pause() {
        player.pause()
    }

    func stop() {
        player.stop()
    }
}
