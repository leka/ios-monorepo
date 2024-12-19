// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// swiftlint:disable:next type_name
public protocol TTSThenValidateGameplayCoordinatorProtocol {
    var uiModel: CurrentValueSubject<TTSUIModel, Never> { get }
    func processUserSelection(choice: TTSUIChoiceModel)
    func validateUserSelection()
}
