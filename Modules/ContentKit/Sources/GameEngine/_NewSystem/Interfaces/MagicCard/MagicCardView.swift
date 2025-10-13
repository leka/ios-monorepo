// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - MagicCardView

public struct MagicCardView: View {
    // MARK: Lifecycle

    public init(viewModel: MagicCardViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)
        ZStack {
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
                                    self.viewModel.enableMagicCardDetection()
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
        }
        .onDisappear {
            Robot.shared.stopLights()
            Robot.shared.displayDefaultWorkingFace()
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

    @StateObject private var viewModel: MagicCardViewViewModel
}

#if DEBUG
    #Preview {
        let coordinator = MagicCardEmptyCoordinator()
        let viewModel = MagicCardViewViewModel(coordinator: coordinator)

        return MagicCardView(viewModel: viewModel)
    }
#endif // DEBUG
