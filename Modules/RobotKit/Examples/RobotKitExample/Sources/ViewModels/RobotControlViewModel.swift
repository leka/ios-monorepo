// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

class RobotControlViewModel: ObservableObject {
    @Published var magicCard: MagicCard = .none
    @Published var magicCardImage: Image = Image(systemName: "photo")

    private let robot: Robot
    private var cancellables: Set<AnyCancellable> = []

    init(robot: Robot) {
        self.robot = robot
        self.robot.onMagicCard()
            .receive(on: DispatchQueue.main)
            .sink {
                self.magicCard = $0
                self.magicCardImage = {
                    switch $0 {
                        case .none:
                            Image(systemName: "cross")
                        case .emergency_stop:
                            Image(systemName: "exclamationmark.octagon")
                        case .dice_roll:
                            Image(systemName: "dice")
                        default:
                            Image(systemName: "photo")
                    }
                }($0)
            }
            .store(in: &cancellables)
    }
}
