// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class GenericViewModel: Identifiable, ObservableObject {
    public var gameplay: any ChoiceGameplayProtocol

    @Published public var choices: [ChoiceModel]
    @Published public var state: GameplayState = .idle

    private var cancellables: Set<AnyCancellable> = []

    public init(gameplay: any ChoiceGameplayProtocol) {
        self.gameplay = gameplay
        self.choices = self.gameplay.choices.value
        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.choices = $0
            }
            .store(in: &cancellables)

        self.gameplay.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.state = $0
            }
            .store(in: &cancellables)
    }

    public func onChoiceTapped(choice: ChoiceModel) {
        gameplay.process(choice: choice)
    }
}
