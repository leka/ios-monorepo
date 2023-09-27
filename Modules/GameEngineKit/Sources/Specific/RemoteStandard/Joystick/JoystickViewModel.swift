// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import SwiftUI
import SwiftUIJoystick

@MainActor
public class JoystickViewModel: ObservableObject {

    // MARK: - Published/public variables
    public var joystickMonitor = JoystickMonitor()

    @Published public var position: CGPoint = CGPoint(x: 0.0, y: 0.0)

    public let dragDiameter: CGFloat
    public let shape: JoystickShape = .circle

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public functions
    init(dragDiameter: CGFloat) {
        self.dragDiameter = dragDiameter

        self.joystickMonitor.$xyPoint
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.position = $0

                let (leftSpeed, rightSpeed) = convertJoystickPosToSpeed(position: $0, maxValue: dragDiameter)

                // TODO(@ladislas): Run motors w/ rotationLeft & Right
                print("LeftSpeed : \(leftSpeed), RightSpeed : \(rightSpeed)")
            })
            .store(in: &cancellables)
    }
}
