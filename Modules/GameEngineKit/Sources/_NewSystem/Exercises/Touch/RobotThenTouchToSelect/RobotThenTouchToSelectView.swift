// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import RobotKit
import SwiftUI

public struct RobotThenTouchToSelectView: View {
    // MARK: Lifecycle

    public init(choices: [TouchToSelect.Choice]) {
        _viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices))

        self.actionType = .color("red")
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard
            let payload = exercise.payload as? TouchToSelect.Payload,
            case let .robot(actionType) = exercise.action
        else {
            log.error("Exercise payload is not .selection and/or Exercise does not contain robot action")
            fatalError("💥 Exercise payload is not .selection and/or Exercise does not contain robot action")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(choices: payload.choices, shared: data))

        self.actionType = actionType

        robot.blacken(.all)
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            Button {
                switch actionType {
                    case let .color(value):
                        robot.shine(.all(in: .init(from: value)))
                    case .audio, .image, .speech:
                        log.error("Action not available for robot: \(actionType)")
                        fatalError("💥 Action not available for robot: \(actionType)")
                }

                withAnimation {
                    didSendCommandToRobot = true
                }
            } label: {
                Image(uiImage: DesignKitAsset.Images.robotFaceSimple.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            .disabled(didSendCommandToRobot)
            .scaleEffect(didSendCommandToRobot ? 1.0 : 0.8, anchor: .center)
            .shadow(
                color: .accentColor.opacity(0.2),
                radius: didSendCommandToRobot ? 6 : 3,
                x: 0,
                y: 3
            )
            .animation(.spring(response: 1, dampingFraction: 0.45), value: didSendCommandToRobot)
            .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .twoChoices:
                    TwoChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .threeChoices:
                    ThreeChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .fourChoices:
                    FourChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .fiveChoices:
                    FiveChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .sixChoices:
                    SixChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                default:
                    EmptyView()
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

    let robot = Robot.shared

    // MARK: Private

    @StateObject private var viewModel: TouchToSelectViewViewModel
    @State private var didSendCommandToRobot = false

    private let actionType: Exercise.Action.ActionType
}
