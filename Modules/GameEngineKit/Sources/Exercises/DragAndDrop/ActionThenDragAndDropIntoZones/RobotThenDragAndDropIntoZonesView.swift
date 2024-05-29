// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

public struct RobotThenDragAndDropIntoZonesView: View {
    // MARK: Lifecycle

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case let .robot(actionType) = exercise.action else {
            log.error("Exercise does not contain robot action")
            fatalError("💥 Exercise does not contain robot action")
        }

        self.exercise = exercise
        self.exerciseSharedData = data
        self.actionType = actionType
        Robot.shared.blacken(.all)
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            ActionButtonRobot(actionType: self.actionType, robotWasTapped: self.$robotWasTapped)
                .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            DragAndDropIntoZonesView(
                exercise: self.exercise,
                data: self.exerciseSharedData
            )
            .animation(.easeOut(duration: 0.3), value: self.robotWasTapped)
            .grayscale(self.robotWasTapped ? 0.0 : 1.0)
            .allowsHitTesting(self.robotWasTapped)

            Spacer()
        }
    }

    // MARK: Private

    private let actionType: Exercise.Action.ActionType
    private var exercise: Exercise
    private var exerciseSharedData: ExerciseSharedData?

    @State private var robotWasTapped = false
}
