// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public class DanceFreezeViewModelDeprecated: Identifiable, ObservableObject {
    private var gameplay: DanceFreezeGameplayDeprecated

    @Published public var progress: CGFloat
    @Published public var state: GameplayStateDeprecated
    @Published public var isDancing: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    public init(gameplay: DanceFreezeGameplayDeprecated) {
        self.gameplay = gameplay

        self.progress = self.gameplay.progress
        self.state = self.gameplay.state

        self.gameplay.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.progress = $0
            }
            .store(in: &cancellables)

        self.gameplay.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.state = $0
            }
            .store(in: &cancellables)

        self.gameplay.$isDancing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.isDancing = $0
            }
            .store(in: &cancellables)
    }

    func onDanceFreezeToggle() {
        gameplay.process()
    }

    func setAudioRecording(audioRecording: AudioRecordingModelDeprecated) {
        gameplay.setAudioPlayer(audioRecording: audioRecording)
    }
}
