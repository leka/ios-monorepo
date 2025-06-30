// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import LocalizationKit
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
        ZStack(alignment: .bottomTrailing) {
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

                Group {
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if self.viewModel.validationState != .hidden {
                Button {
                    self.viewModel.onValidate()
                } label: {
                    Text(l10n.ExerciseView.validateButtonLabel)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 100, height: 25)
                        .padding()
                        .background(
                            Capsule()
                                .fill(self.viewModel.validationState == .enabled ? .cyan : .gray.opacity(0.3))
                                .shadow(radius: 1)
                        )
                }
                .animation(.easeOut(duration: 0.3), value: self.viewModel.validationState)
                .disabled(self.viewModel.validationState == .disabled)
                .padding()
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
    }

    // MARK: Private

    @StateObject private var viewModel: TTSViewViewModel
}

// MARK: - l10n.ExerciseView

extension l10n {
    enum ExerciseView {
        static let validateButtonLabel = LocalizedString("game_engine_kit.exercise_view.validate_button_label",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Validate",
                                                         comment: "The button label to confirm selected choices")
    }
}

#if DEBUG
    #Preview {
        let coordinator = TTSEmptyCoordinator()
        let viewModel = TTSViewViewModel(coordinator: coordinator)

        return TTSView(viewModel: viewModel)
    }
#endif
