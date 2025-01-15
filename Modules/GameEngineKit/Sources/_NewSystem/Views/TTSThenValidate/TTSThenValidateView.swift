// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import LocalizationKit
import SwiftUI

// MARK: - TTSThenValidateView

public struct TTSThenValidateView: View {
    // MARK: Lifecycle

    public init(viewModel: TTSThenValidateViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        VStack(alignment: .center) {
            Spacer()
            Spacer()

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

                VStack(spacing: 30) {
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
                .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                .allowsHitTesting(self.viewModel.didTriggerAction)

                Spacer()
            }

            Spacer()

            Button(String(l10n.TTSThenValidateView.validateButtonLabel.characters)) {
                self.viewModel.onValidate()
            }
            .font(.title2.bold())
            .foregroundColor(.white)
            .frame(width: 100, height: 30)
            .padding()
            .background(
                Capsule()
                    .fill(self.viewModel.isValidationDisabled ? .gray.opacity(0.3) : .green)
                    .shadow(radius: 1)
            )
            .disabled(self.viewModel.isValidationDisabled)
            .animation(.easeOut(duration: 0.3), value: self.viewModel.isValidationDisabled)
            .padding(.vertical, 20)
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

    @StateObject var viewModel: TTSThenValidateViewViewModel
}

// MARK: - l10n.TTSThenValidateView

extension l10n {
    enum TTSThenValidateView {
        static let validateButtonLabel = LocalizedString("game_engine_kit.tts_then_validate_view.validate_button_label",
                                                         bundle: GameEngineKitResources.bundle,
                                                         value: "Validate",
                                                         comment: "The label for the validate button to confirm selected choices")
    }
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSThenValidateGameplayCoordinatorProtocol {
        var uiModel = CurrentValueSubject<TTSUIModel, Never>(TTSUIModel(action: nil, choices: [
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2\nSelected", type: .text,
                                                                                            size: 240, state: .selected)),
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 3\nCorrect", type: .text,
                                                                                            size: 240, state: .correct)),
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "exclamationmark.triangle.fill", type: .sfsymbol,
                                                                                            size: 240, state: .wrong)),
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 5", type: .text, size: 240, state: .idle)),
            TTSUIChoiceModel(view: TTSThenValidateCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 6", type: .text, size: 240, state: .idle)),
        ]))

        func processUserSelection(choice: TTSUIChoiceModel) {
            log.debug("\(choice.id)")
        }

        func validateUserSelection() {
            log.debug("Validate")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

    return TTSThenValidateView(viewModel: viewModel)
}
