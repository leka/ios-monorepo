// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import RobotKit
import SwiftUI

public struct RobotThenTouchToSelectView: View {

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    @StateObject private var viewModel: SelectionViewViewModel
    @State private var didSendCommandToRobot = false

    private let robotMedia: Exercise.Action.RobotMedia

    let robot = Robot.shared

    public init(choices: [SelectionChoice]) {
        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: choices))

        self.robotMedia = .color(value: "red")
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case .selection(let payload) = exercise.payload else {
            fatalError("Exercise payload is not .selection")
        }
        guard case .robot(let robotMedia) = payload.action else {
            fatalError("Exercise payload does not contain an robot action")
        }

        self.robot.blacken(.all)
        self.robotMedia = robotMedia

        self._viewModel = StateObject(
            wrappedValue: SelectionViewViewModel(choices: payload.choices, shared: data))
    }

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            Button {
                switch robotMedia {
                    case .image:
                        fatalError("Image not supported by robot")
                    case .color(let value):
                        robot.shine(.all(in: .init(from: value)))
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

}
