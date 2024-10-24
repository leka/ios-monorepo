// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct TouchToSelectView: View {
    // MARK: Lifecycle

    public init(choices: [TouchToSelect.Choice], shuffle: Bool = false) {
        _viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices, shuffle: shuffle))
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? TouchToSelect.Payload else {
            fatalError("Exercise payload is not .selection")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(
                choices: payload.choices, shuffle: payload.shuffleChoices, shared: data
            ))
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        switch interface {
            case .oneChoice:
                OneChoiceView(viewModel: self.viewModel)

            case .twoChoices:
                TwoChoicesView(viewModel: self.viewModel)

            case .threeChoices:
                ThreeChoicesView(viewModel: self.viewModel)

            case .fourChoices:
                FourChoicesView(viewModel: self.viewModel)

            case .fiveChoices:
                FiveChoicesView(viewModel: self.viewModel)

            case .sixChoices:
                SixChoicesView(viewModel: self.viewModel)

            default:
                ProgressView()
        }
    }

    // MARK: Internal

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    // MARK: Private

    @StateObject private var viewModel: TouchToSelectViewViewModel
}
