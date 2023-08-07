// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class DanceFreezeGameplay {
    var audioPlayer: AudioPlayer
    @Published public var progress: CGFloat = 0.0
    @Published public var state: GameplayState = .idle

    var cancellables: Set<AnyCancellable> = []

    public init() {
        self.audioPlayer = AudioPlayer(song: kAvailableSongs[0])
        self.audioPlayer.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.progress = $0
            }
            .store(in: &cancellables)
    }

    func process() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    func setAudioPlayer(song: AudioRecordingModel) {
        audioPlayer.setAudioPlayer(song: song)
    }
}
