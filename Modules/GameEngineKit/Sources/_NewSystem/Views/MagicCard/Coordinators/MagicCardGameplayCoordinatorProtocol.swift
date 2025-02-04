// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation
import RobotKit

// MARK: - MagicCardGameplayCoordinatorProtocol

public protocol MagicCardGameplayCoordinatorProtocol {
    var action: Exercise.Action { get }
    func enableMagicCardDetection()
    func validateCorrectAnswer()
}
