// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public protocol GameplayProtocol: ObservableObject {
    var name: String { get }
    var choices: [ChoiceViewModel] { get set }
    var isFinished: Bool { get set }

    var choicesPublisher: Published<[ChoiceViewModel]>.Publisher { get }
    var isFinishedPublisher: Published<Bool>.Publisher { get }

    func process(choice: ChoiceViewModel)
}
