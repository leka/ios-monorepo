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

    public init(choices: [SelectionChoice], image: String) {
        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: choices))
        self.image = image
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case .selection(let payload) = exercise.payload else {
            fatalError("Exercise payload is not .selection")
        }
        guard case .ipad(type: .image(name: let name)) = payload.action else {
            fatalError("Exercise payload does not contain an iPad image action")
        }

        self.image = name

        self._viewModel = StateObject(
            wrappedValue: SelectionViewViewModel(choices: payload.choices, shared: data))
    }

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            ActionObserveButton(image: image, imageWasTapped: $imageWasTapped)
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
