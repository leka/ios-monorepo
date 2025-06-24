// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public struct ObserveThenDragAndDropToAssociateView: View {
    // MARK: Lifecycle

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case let .ipad(type: .image(name)) = exercise.action else {
            logGEK.error("Exercise does not contain iPad audio action")
            fatalError("💥 Exercise does not contain iPad audio action")
        }

        self.exercise = exercise
        self.exerciseSharedData = data
        self.image = name
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            ActionButtonObserve(image: self.image, imageWasTapped: self.$imageWasTapped)
                .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            DragAndDropToAssociateView(
                exercise: self.exercise,
                data: self.exerciseSharedData
            )
            .animation(.easeOut(duration: 0.3), value: self.imageWasTapped)
            .grayscale(self.imageWasTapped ? 0.0 : 1.0)
            .allowsHitTesting(self.imageWasTapped)

            Spacer()
        }
    }

    // MARK: Private

    @State private var imageWasTapped = false

    private let image: String
    private var exercise: Exercise
    private var exerciseSharedData: ExerciseSharedData?
}
