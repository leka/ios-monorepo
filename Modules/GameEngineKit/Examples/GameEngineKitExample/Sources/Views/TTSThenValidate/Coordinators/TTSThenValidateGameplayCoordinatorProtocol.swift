// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

// swiftlint:disable:next type_name
protocol TTSThenValidateGameplayCoordinatorProtocol {
    var uiChoices: CurrentValueSubject<[TTSChoiceModel], Never> { get }
    func processUserSelection(choice: TTSChoiceModel)
    func validateUserSelection()
}
