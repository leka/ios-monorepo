// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class DragAndDropZoneViewModel: Identifiable, ObservableObject {
    public var gameplay: any DragAndDropGameplayProtocol

    @Published public var choices: [ChoiceModel]
    @Published public var dropZones: [DragAndDropZoneModel]
    @Published public var state: GameplayStateDeprecated = .idle

    private var cancellables: Set<AnyCancellable> = []

    public init(gameplay: any DragAndDropGameplayProtocol) {
        self.gameplay = gameplay
        self.choices = self.gameplay.choices.value
        self.dropZones = self.gameplay.dropZones.value

        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.choices = $0
            }
            .store(in: &cancellables)

        self.gameplay.dropZones
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.dropZones = $0
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

    public func onChoiceTapped(choice: ChoiceModel, dropZoneName: String) {
        gameplay.process(choice: choice, dropZoneName: dropZoneName)
    }
}
