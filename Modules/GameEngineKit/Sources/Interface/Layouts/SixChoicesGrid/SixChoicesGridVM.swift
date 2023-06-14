// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class SixChoicesGridVM: Identifiable, ObservableObject {
    public let name = "Six choices"
    public var gameplay: any GameplayProtocol

    @Published public var choices: [ChoiceViewModel]
    @Published public var isFinished = false

    private var cancellables: Set<AnyCancellable> = []

    public init(gameplay: any GameplayProtocol) {
        self.gameplay = gameplay
        guard self.gameplay.choices.count == 6 else { fatalError("Wrong size of array") }
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
