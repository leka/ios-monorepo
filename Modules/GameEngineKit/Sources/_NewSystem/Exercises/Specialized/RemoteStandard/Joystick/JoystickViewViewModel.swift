// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI
import SwiftUIJoystick

class JoystickViewViewModel: ObservableObject {
    var joystickMonitor = JoystickMonitor()

    @Published private var position: CGPoint = CGPoint(x: 0.0, y: 0.0)

    let dragDiameter: CGFloat
    let shape: JoystickShape = .circle

    private var cancellables: Set<AnyCancellable> = []

    init(dragDiameter: CGFloat) {
        self.dragDiameter = dragDiameter

        self.joystickMonitor.$xyPoint
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.position = $0

                let (leftSpeed, rightSpeed) = convertJoystickPosToSpeed(position: $0, maxValue: dragDiameter)

                Robot.shared.move(.free(left: Float(leftSpeed), right: Float(rightSpeed)))
            })
            .store(in: &cancellables)
    }
}
