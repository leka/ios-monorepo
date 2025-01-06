// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSView

public struct TTSView: View {
    // MARK: Lifecycle

    public init(viewModel: TTSViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            if let action = self.viewModel.action {
                Button {
                    // nothing to do
                }
                label: {
                    ActionButtonView(action: action)
                        .padding(20)
                }
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            withAnimation {
                                self.viewModel.didTriggerAction = true
                            }
                        }
                )

                Divider()
                    .opacity(0.4)
                    .frame(maxHeight: 500)
                    .padding(.vertical, 20)
            }

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                case .twoChoices:
                    TwoChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                case .threeChoices:
                    ThreeChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                case .fiveChoices:
                    FiveChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

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

    @StateObject private var viewModel: TTSViewViewModel
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSGameplayCoordinatorProtocol {
        var uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: [
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2", type: .text,
                                                                                size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 3\nCorrect", type: .text,
                                                                                size: 240, state: .correct)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "}.triangle.fill", type: .sfsymbol,
                                                                                size: 240, state: .wrong)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 5", type: .text, size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 6", type: .text, size: 240, state: .idle)),
        ]))

        func processUserSelection(choice: TTSUIChoiceModel) {
            log.debug("\(choice.id)")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
