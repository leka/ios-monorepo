// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - AudioPlayerState

enum AudioPlayerState {
    case idle
    case playing
    case finishedPlaying
}

// MARK: - AudioPlayerProtocol

protocol AudioPlayerProtocol {
    var progress: CurrentValueSubject<CGFloat, Never> { get }
    var state: CurrentValueSubject<AudioPlayerState, Never> { get }

    func setAudioData(data: String)
    func play()
    func pause()
    func stop()
}

// MARK: - AudioPlayerViewModel

class AudioPlayerViewModel: ObservableObject {
    // MARK: Lifecycle

    init(player: AudioPlayerProtocol) {
        self.audioPlayer = player

        self.audioPlayer.progress
            .receive(on: DispatchQueue.main)
            .sink { self.progress = $0 }
            .store(in: &self.cancellables)

        self.audioPlayer.state
            .receive(on: DispatchQueue.main)
            .sink { self.state = $0 }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var audioPlayer: any AudioPlayerProtocol

    @Published var progress: CGFloat = 0.0
    @Published var state: AudioPlayerState = .idle

    func setAudioData(data: String) {
        self.audioPlayer.setAudioData(data: data)
    }

    func play() {
        self.audioPlayer.play()
    }

    func pause() {
        self.audioPlayer.pause()
    }

    func stop() {
        self.audioPlayer.stop()
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []
}
