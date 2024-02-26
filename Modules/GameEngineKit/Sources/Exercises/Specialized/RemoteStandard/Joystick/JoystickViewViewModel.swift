// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI
import SwiftUIJoystick

class JoystickViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(dragDiameter: CGFloat) {
        self.dragDiameter = dragDiameter

        self.joystickMonitor.$xyPoint
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.position = $0

                let (leftSpeed, rightSpeed) = convertJoystickPosToSpeed(position: $0, maxValue: dragDiameter)

                Robot.shared.move(.free(left: Float(leftSpeed), right: Float(rightSpeed)))
            })
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    var joystickMonitor = JoystickMonitor()

    let dragDiameter: CGFloat
    let shape: JoystickShape = .circle

    // MARK: Private

    @Published private var position: CGPoint = .init(x: 0.0, y: 0.0)

    private var cancellables: Set<AnyCancellable> = []
}
