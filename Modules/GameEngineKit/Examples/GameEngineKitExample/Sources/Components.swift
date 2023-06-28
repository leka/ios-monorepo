// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

let threeRawItems = ["red", "blue", "yellow"]
let threeTypes = [DataType.color, DataType.text, DataType.color]

let sixRawItems = ["red", "blue", "yellow", "dummy_1", "yellow", "pink"]
let sixTypes = [DataType.color, DataType.text, DataType.color, DataType.image, DataType.color, DataType.text]

let listThreeChoices = (0..<3)
    .map {
        ChoiceViewModel(item: threeRawItems[$0], type: threeTypes[$0])
    }

let listSixChoices = (0..<6)
    .map {
        ChoiceViewModel(item: sixRawItems[$0], type: sixTypes[$0])
    }

public let dataThree = Data(
    choices: listThreeChoices,
    rightAnswers: [listThreeChoices[1]])

public let dataSix = Data(
    choices: listSixChoices,
    rightAnswers: [listSixChoices[2], listSixChoices[3], listSixChoices[4]])

public var gameEngineThree = GameEngine(
    data: dataThree, gameplay: .selectTheRightAnswer)

public var gameEngineSix = GameEngine(data: dataSix, gameplay: .selectAllRightAnswers)
