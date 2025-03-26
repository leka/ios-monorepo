// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct MemoryView: View {
    // MARK: Lifecycle

    public init(choices: [Memory.Choice]) {
        _viewModel = StateObject(wrappedValue: MemoryViewViewModel(choices: choices))
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? Memory.Payload else {
            fatalError("Exercise payload is not .memory")
        }

        _viewModel = StateObject(
            wrappedValue: MemoryViewViewModel(
                choices: payload.choices, shared: data, shuffleChoices: payload.shuffleChoices
            ))
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        switch interface {
            case .twoChoices:
                TwoChoicesView(viewModel: self.viewModel)
                    .allowsHitTesting(self.viewModel.isTappable)

            case .fourChoices:
                FourChoicesView(viewModel: self.viewModel)
                    .allowsHitTesting(self.viewModel.isTappable)

            case .sixChoices:
                SixChoicesView(viewModel: self.viewModel)
                    .allowsHitTesting(self.viewModel.isTappable)

            case .eightChoices:
                EightChoicesView(viewModel: self.viewModel)
                    .allowsHitTesting(self.viewModel.isTappable)

            default:
                ProgressView()
        }
    }

    // MARK: Internal

    enum Interface: Int {
        case twoChoices = 2
        case fourChoices = 4
        case sixChoices = 6
        case eightChoices = 8
    }

    // MARK: Private

    @StateObject private var viewModel: MemoryViewViewModel
}
