// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ObserveThenTouchToSelectView: View {
    // MARK: Lifecycle

    public init(choices: [TouchToSelect.Choice], image: String, shuffle: Bool = false) {
        _viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices, shuffle: shuffle))
        self.image = image
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? TouchToSelect.Payload else {
            log.error("Invalid payload type: expected TouchToSelect.Payload, got \(type(of: exercise.payload))")
            fatalError("💥 Invalid payload type: expected TouchToSelect.Payload, got \(type(of: exercise.payload))")
        }

        switch exercise.action {
            case let .ipad(type: .image(name)):
                self.image = name
            case let .ipad(type: .sfsymbol(name)):
                self.image = name
            default:
                log.error("Invalid action type: expected iPad image or sfsymbol, got \(String(describing: exercise.action))")
                fatalError("💥 Invalid action type: expected iPad image or sfsymbol, got \(String(describing: exercise.action))")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(choices: payload.choices, shuffle: payload.shuffleChoices, shared: data))
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
                        .grayscale(self.imageWasTapped ? 0.0 : 1.0)

                case .twoChoices:
                    TwoChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)
                        .grayscale(self.imageWasTapped ? 0.0 : 1.0)

                case .threeChoices:
                    ThreeChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)
                        .grayscale(self.imageWasTapped ? 0.0 : 1.0)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)
                        .grayscale(self.imageWasTapped ? 0.0 : 1.0)

                case .fiveChoices:
                    FiveChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)
                        .grayscale(self.imageWasTapped ? 0.0 : 1.0)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel, isTappable: self.imageWasTapped)
                        .onTapGestureIf(self.imageWasTapped) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)
                        .grayscale(self.imageWasTapped ? 0.0 : 1.0)

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
