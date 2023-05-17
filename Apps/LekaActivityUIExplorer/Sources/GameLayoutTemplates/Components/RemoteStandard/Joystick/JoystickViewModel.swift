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

                self.leftMotor = self.convertPosXToPWM(posX: $0.x, posY: $0.y)
                self.rightMotor = self.convertPosYToPWM(posX: $0.x, posY: $0.y)
            })
            .store(in: &cancellables)
    }

    private func convertPosXToPWM(posX: CGFloat, posY: CGFloat) -> CGFloat {
        let leftPWM = 255.0 / dragDiameter * (posX - posY)

        return clamp(leftPWM, lower: -255, upper: 255)
    }

    private func convertPosYToPWM(posX: CGFloat, posY: CGFloat) -> CGFloat {
        let rightPWM = -255 / dragDiameter * (posX + posY)

        return clamp(rightPWM, lower: -255, upper: 255)
    }

    // MARK: - Private functions
    fileprivate func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }

}
