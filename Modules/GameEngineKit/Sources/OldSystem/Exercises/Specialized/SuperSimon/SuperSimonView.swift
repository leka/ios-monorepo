// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SuperSimonView

public struct SuperSimonView: View {
    // MARK: Lifecycle

    public init(level: SuperSimon.Level, shuffle: Bool = false) {
        _viewModel = StateObject(wrappedValue: SuperSimonViewViewModel(level: level, shuffle: shuffle))
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? SuperSimon.Payload else {
            log.error("Exercise payload is not .selection")
            fatalError("💥 Exercise payload is not .selection")
        }

        _viewModel = StateObject(
            wrappedValue: SuperSimonViewViewModel(level: payload.level, shared: data))
    }

    // MARK: Public

    public var body: some View {
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
                    TwoChoicesView(viewModel: self.viewModel, isTappable: self.viewModel.enableChoices)
                        .onTapGestureIf(self.viewModel.enableChoices) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.enableChoices)
                        .grayscale(self.viewModel.enableChoices ? 0.0 : 1.0)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel, isTappable: self.viewModel.enableChoices)
                        .onTapGestureIf(self.viewModel.enableChoices) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.enableChoices)
                        .grayscale(self.viewModel.enableChoices ? 0.0 : 1.0)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel, isTappable: self.viewModel.enableChoices)
                        .onTapGestureIf(self.viewModel.enableChoices) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.viewModel.enableChoices)
                        .grayscale(self.viewModel.enableChoices ? 0.0 : 1.0)

                default:
                    Text(l10n.SuperSimonView.typeUnknownError)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            log.error("Interface \(interface) not implemented")
                        }
            }

            Spacer()
        }
    }

    // MARK: Internal

    enum Interface: Int {
        case twoChoices = 2
        case fourChoices = 4
        case sixChoices = 6
    }

    // MARK: Private

    @StateObject private var viewModel: SuperSimonViewViewModel
    @StateObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.SuperSimonView

extension l10n {
    enum SuperSimonView {
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
