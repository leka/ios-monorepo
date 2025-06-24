// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewMemoryView

public struct NewMemoryView: View {
    // MARK: Lifecycle

    public init(viewModel: NewMemoryViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        VStack {
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

                case .sevenChoices:
                    SevenChoicesView(viewModel: self.viewModel)

                case .eightChoices:
                    EightChoicesView(viewModel: self.viewModel)

                default:
                    ProgressView()
            }
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
        case sevenChoices
        case eightChoices
    }

    // MARK: Private

    @StateObject private var viewModel: NewMemoryViewViewModel
}
