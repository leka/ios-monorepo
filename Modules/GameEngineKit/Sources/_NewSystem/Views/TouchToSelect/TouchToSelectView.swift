// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct TouchToSelectView: View {

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    @StateObject private var viewModel: SelectionViewViewModel

    public init(choices: [SelectionChoice], shuffle: Bool = false) {
        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: choices, shuffle: shuffle))
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case .selection(let payload) = exercise.payload else {
            fatalError("Exercise payload is not .selection")
        }

        self._viewModel = StateObject(
            wrappedValue: SelectionViewViewModel(
                choices: payload.choices, shuffle: payload.shuffleChoices, shared: data))
    }

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        switch interface {
            case .oneChoice:
                OneChoiceView(viewModel: viewModel)

            case .twoChoices:
                TwoChoicesView(viewModel: viewModel)

            case .threeChoices:
                ThreeChoicesView(viewModel: viewModel)

            case .fourChoices:
                FourChoicesView(viewModel: viewModel)

            case .fiveChoices:
                FiveChoicesView(viewModel: viewModel)

            case .sixChoices:
                SixChoicesView(viewModel: viewModel)

            default:
                Text("❌ Interface not available for \(viewModel.choices.count) choices")
        }
    }

}
