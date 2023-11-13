// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ObserveThenTouchToSelectView: View {

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    @StateObject private var viewModel: SelectionViewViewModel

    @State private var imageWasTapped = false

    private let image: String

    public init(choices: [TouchSelection.Choice], image: String) {
        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: choices))
        self.image = image
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard
            case .selection(let payload) = exercise.payload,
            case .ipad(type: .image(let name)) = exercise.action
        else {
            log.error("Exercise payload is not .selection and/or Exercise does not contain iPad image action")
            fatalError("💥 Exercise payload is not .selection and/or Exercise does not contain iPad image action")
        }

        self._viewModel = StateObject(
            wrappedValue: SelectionViewViewModel(choices: payload.choices, shared: data))

        self.image = name
    }

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            ActionButtonObserve(image: image, imageWasTapped: $imageWasTapped)
                .padding(20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: viewModel, isTappable: imageWasTapped)
                        .onTapGestureIf(imageWasTapped) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageWasTapped)

                case .twoChoices:
                    TwoChoicesView(viewModel: viewModel, isTappable: imageWasTapped)
                        .onTapGestureIf(imageWasTapped) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageWasTapped)

                case .threeChoices:
                    ThreeChoicesView(viewModel: viewModel, isTappable: imageWasTapped)
                        .onTapGestureIf(imageWasTapped) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageWasTapped)

                case .fourChoices:
                    FourChoicesView(viewModel: viewModel, isTappable: imageWasTapped)
                        .onTapGestureIf(imageWasTapped) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageWasTapped)

                case .fiveChoices:
                    FiveChoicesView(viewModel: viewModel, isTappable: imageWasTapped)
                        .onTapGestureIf(imageWasTapped) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageWasTapped)

                case .sixChoices:
                    SixChoicesView(viewModel: viewModel, isTappable: imageWasTapped)
                        .onTapGestureIf(imageWasTapped) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageWasTapped)

                default:
                    Text("❌ Interface not available for \(viewModel.choices.count) choices")
            }

            Spacer()
        }
    }

}
