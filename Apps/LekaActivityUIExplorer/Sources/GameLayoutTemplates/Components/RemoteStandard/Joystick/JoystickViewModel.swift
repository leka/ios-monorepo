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

    @Published public var posX: CGFloat = 0.0
    @Published public var posY: CGFloat = 0.0

    @Published public var leftMotor: CGFloat = 0.0
    @Published public var rightMotor: CGFloat = 0.0

    public let dragDiameter: CGFloat
    public let shape: JoystickShape = .circle

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public functions
    init(dragDiameter: CGFloat) {
        self.dragDiameter = dragDiameter

        self.joystickMonitor.$xyPoint
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.posX = $0.x
                self.posY = $0.y

                self.leftMotor = convertJoystickPosXToPWM(posX: $0.x, posY: $0.y, maxValue: dragDiameter)
                self.rightMotor = convertJoystickPosYToPWM(posX: $0.x, posY: $0.y, maxValue: dragDiameter)
            })
            .store(in: &cancellables)
    }
}
