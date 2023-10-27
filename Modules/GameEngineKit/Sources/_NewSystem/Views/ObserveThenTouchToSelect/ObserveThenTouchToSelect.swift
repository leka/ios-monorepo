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
    @State private var imageHasBeenObserved = false
    private let image: String

    public init(choices: [SelectionChoice], image: String) {
        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: choices))
        self.image = image
    }

    public init(exercise: Exercise) {
        guard case .selection(let payload) = exercise.payload else {
            fatalError("Exercise payload is not .selection")
        }
        guard let media = payload.media else {
            fatalError("Exercise payload has no media")
        }

        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: payload.choices))
        self.image = media
    }

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            ObserveButton(image: image, imageHasBeenObserved: $imageHasBeenObserved)
                .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: viewModel, isTappable: imageHasBeenObserved)
                        .onTapGestureIf(imageHasBeenObserved) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageHasBeenObserved)

                case .twoChoices:
                    TwoChoicesView(viewModel: viewModel, isTappable: imageHasBeenObserved)
                        .onTapGestureIf(imageHasBeenObserved) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageHasBeenObserved)

                case .threeChoices:
                    ThreeChoicesView(viewModel: viewModel, isTappable: imageHasBeenObserved)
                        .onTapGestureIf(imageHasBeenObserved) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageHasBeenObserved)

                case .fourChoices:
                    FourChoicesView(viewModel: viewModel, isTappable: imageHasBeenObserved)
                        .onTapGestureIf(imageHasBeenObserved) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageHasBeenObserved)

                case .fiveChoices:
                    FiveChoicesView(viewModel: viewModel, isTappable: imageHasBeenObserved)
                        .onTapGestureIf(imageHasBeenObserved) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageHasBeenObserved)

                case .sixChoices:
                    SixChoicesView(viewModel: viewModel, isTappable: imageHasBeenObserved)
                        .onTapGestureIf(imageHasBeenObserved) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: imageHasBeenObserved)

                default:
                    Text("❌ Interface not available for \(viewModel.choices.count) choices")
            }

            Spacer()
        }
    }

}
