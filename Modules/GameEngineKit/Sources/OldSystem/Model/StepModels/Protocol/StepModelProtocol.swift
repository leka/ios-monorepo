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
    case dragAndDropAllAnswersOnTheRightZone
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
    case listenOneChoice(AudioRecordingModelDeprecated)
    case listenTwoChoices(AudioRecordingModelDeprecated)
    case listenThreeChoices(AudioRecordingModelDeprecated)
    case listenThreeChoicesInline(AudioRecordingModelDeprecated)
    case listenFourChoices(AudioRecordingModelDeprecated)
    case listenSixChoices(AudioRecordingModelDeprecated)
    case dragAndDropOneZoneOneOrMoreChoices(hints: Bool)
    case dragAndDropTwoZonesOneOrMoreChoices(hints: Bool)
}

public protocol StepModelProtocol {
    var choices: [ChoiceModel] { get set }
    var gameplay: GameplayType { get set }
    var interface: InterfaceType { get set }
}
