// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class DanceFreezeGameplay {
    var audioPlayer: AudioPlayer
    @Published public var progress: CGFloat = 0.0
    @Published public var state: GameplayState = .idle
    @Published public var isDancing: Bool = false

    var cancellables: Set<AnyCancellable> = []

    public init() {
        self.audioPlayer = AudioPlayer(audioRecording: kAvailableSongs[0])
        self.audioPlayer.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.progress = $0
            }
            .store(in: &cancellables)
    }

    func process() {
        if progress == 1.0 {
            state = .finished
            return
        }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            isDancing = false
            // TODO(@ladislas): Stop motors and lights
        } else {
            audioPlayer.play()
            isDancing = true
            // TODO(@ladislas): Run motors and lights to dance
        }
    }

    func setAudioPlayer(audioRecording: AudioRecordingModel) {
        audioPlayer.setAudioPlayer(audioRecording: audioRecording)
    }
}
