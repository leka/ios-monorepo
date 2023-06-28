// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class GenericViewModel: Identifiable, ObservableObject {
    public var gameplay: any GameplayProtocol

    @Published public var choices: [ChoiceViewModel]
    @Published public var isFinished = false

    public var choicesPublisher: Published<[ChoiceViewModel]>.Publisher { $choices }
    public var isFinishedPublisher: Published<Bool>.Publisher { $isFinished }

    private var cancellables: Set<AnyCancellable> = []

    public init(gameplay: any GameplayProtocol) {
        self.gameplay = gameplay
        self.choices = self.gameplay.choices
        self.gameplay.choicesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.choices = $0
            }
            .store(in: &cancellables)

        self.gameplay.isFinishedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.isFinished = $0
            }
            .store(in: &cancellables)
    }

    public func onChoiceTapped(choice: ChoiceViewModel) {
        gameplay.process(choice: choice)
    }
}
