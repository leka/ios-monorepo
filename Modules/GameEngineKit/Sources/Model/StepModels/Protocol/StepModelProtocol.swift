// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum GameplayType {
    case undefined
    case selectTheRightAnswer
    case selectAllRightAnswers
    case selectSomeRightAnswers(Int)
    case colorBingo
    case superSimon([Int])
    case dragAndDropOneAnswerOnTheRightZone
}

public enum InterfaceType {
    case undefined
    case oneChoice
    case twoChoices
    case threeChoices
    case threeChoicesInline
    case fourChoices
    case fourChoicesInline
    case fiveChoices
    case sixChoices
    case listenOneChoice(AudioRecordingModel)
    case listenTwoChoices(AudioRecordingModel)
    case listenThreeChoices(AudioRecordingModel)
    case listenThreeChoicesInline(AudioRecordingModel)
    case listenFourChoices(AudioRecordingModel)
    case listenSixChoices(AudioRecordingModel)
    case dragAndDropOneAreaOneOrMoreChoices
}

public protocol StepModelProtocol {
    var choices: [ChoiceModel] { get set}
    var gameplay: GameplayType { get set }
    var interface: InterfaceType { get set }
}
