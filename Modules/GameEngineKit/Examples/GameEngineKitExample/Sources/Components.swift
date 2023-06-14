// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

public let gameplayOneRightAnswerThreeInline = SelectTheRightAnswer(
    choices: ChoiceViewModel.listThreeChoices, rightAnswers: [ChoiceViewModel.listThreeChoices[1]])

public let gameplayAllRightAnswerThreeInline = SelectAllRightAnswers(
    choices: ChoiceViewModel.listThreeChoices,
    rightAnswers: [ChoiceViewModel.listThreeChoices[1], ChoiceViewModel.listThreeChoices[2]])

public let gameplaySomeRightAnswerThreeInline = SelectSomeRightAnswers(
    choices: ChoiceViewModel.listThreeChoices,
    rightAnswers: [ChoiceViewModel.listThreeChoices[1], ChoiceViewModel.listThreeChoices[2]],
    rightAnswersToFound: 2)

public let gameplayOneRightAnswerSixGrid = SelectTheRightAnswer(
    choices: ChoiceViewModel.listSixChoices, rightAnswers: [ChoiceViewModel.listSixChoices[1]])

public let gameplayAllRightAnswerSixGrid = SelectAllRightAnswers(
    choices: ChoiceViewModel.listSixChoices,
    rightAnswers: [
        ChoiceViewModel.listSixChoices[1], ChoiceViewModel.listSixChoices[5], ChoiceViewModel.listSixChoices[3],
    ])

public let gameplaySomeRightAnswerSixGrid = SelectSomeRightAnswers(
    choices: ChoiceViewModel.listSixChoices,
    rightAnswers: [
        ChoiceViewModel.listSixChoices[1], ChoiceViewModel.listSixChoices[4], ChoiceViewModel.listSixChoices[3],
    ], rightAnswersToFound: 2)

public let oneAnswerThreeInlineVM = ThreeChoicesInlineVM(gameplay: gameplayOneRightAnswerThreeInline)
public let allAnswersThreeInlineVM = ThreeChoicesInlineVM(gameplay: gameplayAllRightAnswerThreeInline)
public let someAnswersThreeInlineVM = ThreeChoicesInlineVM(gameplay: gameplaySomeRightAnswerThreeInline)

public let oneAnswerSixGridVM = SixChoicesGridVM(gameplay: gameplayOneRightAnswerSixGrid)
public let allAnswersSixGridVM = SixChoicesGridVM(gameplay: gameplayAllRightAnswerSixGrid)
public let someAnswersSixGridVM = SixChoicesGridVM(gameplay: gameplaySomeRightAnswerSixGrid)
