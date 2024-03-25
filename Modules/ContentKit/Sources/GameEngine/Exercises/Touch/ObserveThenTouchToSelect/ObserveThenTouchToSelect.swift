// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

import SwiftUI

public struct ObserveThenTouchToSelectView: View {
    // MARK: Lifecycle

    public init(choices: [TouchToSelect.Choice], image: String) {
        _viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices))
        self.image = image
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? TouchToSelect.Payload,
              case let .ipad(type: .image(name)) = exercise.action
        else {
            log.error("Exercise payload is not .selection and/or Exercise does not contain iPad image action")
            fatalError("💥 Exercise payload is not .selection and/or Exercise does not contain iPad image action")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(choices: payload.choices, shared: data))

        self.image = name
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            ActionButtonObserve(image: self.image, imageWasTapped: self.$imageWasTapped)
                .padding(20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)

                case .twoChoices:
                    TwoChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)

                case .threeChoices:
                    ThreeChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)

                case .fiveChoices:
                    FiveChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)

                default:
                    ProgressView()
            }

            Spacer()
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

    @State private var imageWasTapped = false

    private let image: String
}
