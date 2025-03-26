// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - NewSuperSimonView

struct NewSuperSimonView: View {
    // MARK: Lifecycle

    init(viewModel: NewSuperSimonViewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    enum Interface: Int {
        case twoChoices = 2
        case fourChoices = 4
        case sixChoices = 6
    }

    var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            Button {
                self.viewModel.onRobotTapped()
            } label: {
                Image(uiImage: DesignKitAsset.Images.robotFaceAction.image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(self.styleManager.accentColor!)
                    .frame(width: 130, height: 130)
                    .padding(10)
            }
            .frame(width: 200)
            .disabled(self.viewModel.disableRobot)
            .opacity(self.viewModel.disableRobot ? 0.3 : 1.0)
            .buttonStyle(ActionButtonStyle(progress: 0.0))
            .animation(.spring(response: 0.3, dampingFraction: 0.45), value: self.viewModel.disableRobot)
            .scaleEffect(self.viewModel.disableRobot ? 0.95 : 1.0, anchor: .center)
            .shadow(
                color: .accentColor.opacity(0.2),
                radius: self.viewModel.disableRobot ? 6 : 3, x: 0, y: 3
            )

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            switch interface {
                case .twoChoices:
                    TwoChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel)
                        .colorMultiply(self.viewModel.didTriggerAction ? .white : .gray.opacity(0.4))
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.didTriggerAction)
                        .allowsHitTesting(self.viewModel.didTriggerAction)

                default:
                    Text(l10n.NewSuperSimonView.typeUnknownError)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            logGEK.error("Interface \(interface) not implemented")
                        }
            }

            Spacer()
        }
    }

    // MARK: Private

    @StateObject private var styleManager: StyleManager = .shared

    private let viewModel: NewSuperSimonViewViewModel
}

// MARK: - l10n.NewSuperSimonView

extension l10n {
    enum NewSuperSimonView {
        static let buttonLabel = LocalizedString("game_engine_kit.super_simon.button_label",
                                                 bundle: GameEngineKitResources.bundle,
                                                 value: "Tap Leka",
                                                 comment: "Super Simon button label")

        static let typeUnknownError = LocalizedString("game_engine_kit.super_simon.type_unknown_error",
                                                      bundle: GameEngineKitResources.bundle,
                                                      value: "❌ ERROR\nInterface not implemented",
                                                      comment: "Super Simon interface unknown error label")
    }
}
